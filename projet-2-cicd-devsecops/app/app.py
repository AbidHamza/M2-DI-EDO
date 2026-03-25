"""
Finance App - DevSecOps Demo Application
=========================================
A simplified financial management API built with Flask.
Provides endpoints for transactions, balance checks, and transfers.
Includes Prometheus metrics and structured logging.
"""

import uuid
import logging
from datetime import datetime, timezone

from flask import Flask, request, jsonify
from prometheus_client import (
    Counter,
    Histogram,
    Gauge,
    generate_latest,
    CONTENT_TYPE_LATEST,
)

# ---------------------------------------------------------------------------
# Application setup
# ---------------------------------------------------------------------------

app = Flask(__name__)

# Structured logging configuration
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s - %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S%z",
)
logger = logging.getLogger("finance-app")

# ---------------------------------------------------------------------------
# Prometheus metrics
# ---------------------------------------------------------------------------

REQUEST_COUNT = Counter(
    "finance_app_requests_total",
    "Total number of HTTP requests",
    ["method", "endpoint", "status"],
)

REQUEST_DURATION = Histogram(
    "finance_app_request_duration_seconds",
    "HTTP request duration in seconds",
    ["method", "endpoint"],
    buckets=[0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0],
)

TRANSACTIONS_CREATED = Counter(
    "finance_app_transactions_created_total",
    "Total number of transactions created",
)

TRANSFER_AMOUNT = Counter(
    "finance_app_transfer_amount_total",
    "Total amount transferred (EUR)",
)

ACTIVE_ACCOUNTS = Gauge(
    "finance_app_active_accounts",
    "Number of active accounts",
)

ERROR_COUNT = Counter(
    "finance_app_errors_total",
    "Total number of errors",
    ["type"],
)

# ---------------------------------------------------------------------------
# In-memory data store
# ---------------------------------------------------------------------------

# Pre-populated accounts with initial balances (EUR)
accounts = {
    "ACC001": {"balance": 1000.00, "owner": "Alice Martin", "currency": "EUR"},
    "ACC002": {"balance": 2500.00, "owner": "Bob Dupont", "currency": "EUR"},
    "ACC003": {"balance": 500.00, "owner": "Charlie Durand", "currency": "EUR"},
}

# Transaction history
transactions = []

# Set initial gauge value
ACTIVE_ACCOUNTS.set(len(accounts))

# Application metadata
APP_VERSION = "1.0.0"
APP_NAME = "finance-app"

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------


def _now_iso():
    """Return current UTC time in ISO 8601 format."""
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _generate_txn_id():
    """Generate a unique transaction identifier."""
    return f"txn_{uuid.uuid4().hex[:12]}"


def _validate_amount(amount):
    """
    Validate that the amount is a positive number.
    Returns (valid: bool, error_message: str | None).
    """
    if amount is None:
        return False, "Amount is required"
    try:
        amount = float(amount)
    except (TypeError, ValueError):
        return False, "Amount must be a number"
    if amount <= 0:
        return False, "Amount must be positive"
    if amount > 1_000_000:
        return False, "Amount exceeds maximum allowed (1,000,000 EUR)"
    return True, None


# ---------------------------------------------------------------------------
# Middleware: track request metrics
# ---------------------------------------------------------------------------


@app.before_request
def _start_timer():
    """Record the start time of each request."""
    request._start_time = datetime.now(timezone.utc)


@app.after_request
def _track_metrics(response):
    """Record request count and duration after each request."""
    # Skip metrics endpoint to avoid recursion
    if request.path == "/metrics":
        return response

    endpoint = request.path
    method = request.method
    status = str(response.status_code)

    REQUEST_COUNT.labels(method=method, endpoint=endpoint, status=status).inc()

    if hasattr(request, "_start_time"):
        duration = (datetime.now(timezone.utc) - request._start_time).total_seconds()
        REQUEST_DURATION.labels(method=method, endpoint=endpoint).observe(duration)

    return response


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------


@app.route("/health", methods=["GET"])
def health():
    """
    Health check endpoint.
    Used by Docker HEALTHCHECK, Prometheus, Ansible, and load balancers.
    """
    logger.info("Health check requested")
    return jsonify(
        {
            "status": "healthy",
            "version": APP_VERSION,
            "service": APP_NAME,
            "timestamp": _now_iso(),
            "accounts_count": len(accounts),
        }
    ), 200


@app.route("/metrics", methods=["GET"])
def metrics():
    """
    Prometheus metrics endpoint.
    Exposes all application metrics in Prometheus exposition format.
    """
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}


@app.route("/api/transactions", methods=["GET"])
def get_transactions():
    """
    List all transactions.
    Supports optional query parameter 'account_id' to filter by account.
    """
    account_id = request.args.get("account_id")

    if account_id:
        filtered = [
            t
            for t in transactions
            if t["from_account"] == account_id or t["to_account"] == account_id
        ]
        logger.info(
            "Transactions listed for account %s: %d found", account_id, len(filtered)
        )
        return jsonify({"transactions": filtered, "count": len(filtered)}), 200

    logger.info("All transactions listed: %d total", len(transactions))
    return jsonify({"transactions": transactions, "count": len(transactions)}), 200


@app.route("/api/transactions", methods=["POST"])
def create_transaction():
    """
    Create a new transaction record.
    Expects JSON body with: from_account, to_account, amount, type.
    """
    data = request.get_json()
    if not data:
        ERROR_COUNT.labels(type="invalid_request").inc()
        return jsonify({"error": "Request body must be JSON"}), 400

    # Validate required fields
    required_fields = ["from_account", "to_account", "amount"]
    for field in required_fields:
        if field not in data:
            ERROR_COUNT.labels(type="missing_field").inc()
            return jsonify({"error": f"Missing required field: {field}"}), 400

    # Validate amount
    valid, error_msg = _validate_amount(data["amount"])
    if not valid:
        ERROR_COUNT.labels(type="invalid_amount").inc()
        return jsonify({"error": error_msg}), 400

    # Validate accounts exist
    if data["from_account"] not in accounts:
        ERROR_COUNT.labels(type="account_not_found").inc()
        return jsonify({"error": f"Account {data['from_account']} not found"}), 404

    if data["to_account"] not in accounts:
        ERROR_COUNT.labels(type="account_not_found").inc()
        return jsonify({"error": f"Account {data['to_account']} not found"}), 404

    # Create the transaction record
    txn = {
        "id": _generate_txn_id(),
        "from_account": data["from_account"],
        "to_account": data["to_account"],
        "amount": float(data["amount"]),
        "type": data.get("type", "transfer"),
        "timestamp": _now_iso(),
        "status": "completed",
    }

    transactions.append(txn)
    TRANSACTIONS_CREATED.inc()

    logger.info(
        "Transaction created: %s -> %s, amount=%.2f EUR",
        txn["from_account"],
        txn["to_account"],
        txn["amount"],
    )

    return jsonify({"message": "Transaction created successfully", "transaction": txn}), 201


@app.route("/api/balance", methods=["GET"])
def get_balance():
    """
    Get the balance of a specific account.
    Requires query parameter 'account_id'.
    """
    account_id = request.args.get("account_id")

    if not account_id:
        ERROR_COUNT.labels(type="missing_parameter").inc()
        return jsonify({"error": "Query parameter 'account_id' is required"}), 400

    if account_id not in accounts:
        ERROR_COUNT.labels(type="account_not_found").inc()
        return jsonify({"error": f"Account {account_id} not found"}), 404

    account = accounts[account_id]
    logger.info("Balance checked for %s: %.2f EUR", account_id, account["balance"])

    return jsonify(
        {
            "account_id": account_id,
            "owner": account["owner"],
            "balance": account["balance"],
            "currency": account["currency"],
            "last_updated": _now_iso(),
        }
    ), 200


@app.route("/api/transfer", methods=["POST"])
def transfer():
    """
    Transfer funds between two accounts.
    Expects JSON body with: from_account, to_account, amount.
    Validates sufficient balance before executing the transfer.
    """
    data = request.get_json()
    if not data:
        ERROR_COUNT.labels(type="invalid_request").inc()
        return jsonify({"error": "Request body must be JSON"}), 400

    # Validate required fields
    required_fields = ["from_account", "to_account", "amount"]
    for field in required_fields:
        if field not in data:
            ERROR_COUNT.labels(type="missing_field").inc()
            return jsonify({"error": f"Missing required field: {field}"}), 400

    from_acc = data["from_account"]
    to_acc = data["to_account"]

    # Validate amount
    valid, error_msg = _validate_amount(data["amount"])
    if not valid:
        ERROR_COUNT.labels(type="invalid_amount").inc()
        return jsonify({"error": error_msg}), 400

    amount = float(data["amount"])

    # Validate accounts exist
    if from_acc not in accounts:
        ERROR_COUNT.labels(type="account_not_found").inc()
        return jsonify({"error": f"Account {from_acc} not found"}), 404

    if to_acc not in accounts:
        ERROR_COUNT.labels(type="account_not_found").inc()
        return jsonify({"error": f"Account {to_acc} not found"}), 404

    # Cannot transfer to same account
    if from_acc == to_acc:
        ERROR_COUNT.labels(type="invalid_transfer").inc()
        return jsonify({"error": "Cannot transfer to the same account"}), 400

    # Check sufficient balance
    if accounts[from_acc]["balance"] < amount:
        ERROR_COUNT.labels(type="insufficient_balance").inc()
        logger.warning(
            "Transfer rejected: %s has %.2f EUR, requested %.2f EUR",
            from_acc,
            accounts[from_acc]["balance"],
            amount,
        )
        return jsonify(
            {
                "error": "Insufficient balance",
                "available_balance": accounts[from_acc]["balance"],
                "requested_amount": amount,
            }
        ), 400

    # Execute the transfer
    accounts[from_acc]["balance"] -= amount
    accounts[to_acc]["balance"] += amount

    # Record the transaction
    txn = {
        "id": _generate_txn_id(),
        "from_account": from_acc,
        "to_account": to_acc,
        "amount": amount,
        "type": "transfer",
        "timestamp": _now_iso(),
        "status": "completed",
    }
    transactions.append(txn)

    # Update metrics
    TRANSACTIONS_CREATED.inc()
    TRANSFER_AMOUNT.inc(amount)

    logger.info(
        "Transfer completed: %s -> %s, amount=%.2f EUR (balances: %.2f / %.2f)",
        from_acc,
        to_acc,
        amount,
        accounts[from_acc]["balance"],
        accounts[to_acc]["balance"],
    )

    return jsonify(
        {
            "message": "Transfer completed successfully",
            "transfer": {
                "id": txn["id"],
                "from_account": from_acc,
                "to_account": to_acc,
                "amount": amount,
                "from_balance": accounts[from_acc]["balance"],
                "to_balance": accounts[to_acc]["balance"],
                "timestamp": txn["timestamp"],
            },
        }
    ), 200


# ---------------------------------------------------------------------------
# Error handlers
# ---------------------------------------------------------------------------


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors."""
    ERROR_COUNT.labels(type="not_found").inc()
    return jsonify({"error": "Resource not found"}), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors."""
    ERROR_COUNT.labels(type="internal_error").inc()
    logger.error("Internal server error: %s", str(error))
    return jsonify({"error": "Internal server error"}), 500


# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    logger.info("Starting Finance App v%s", APP_VERSION)
    app.run(host="0.0.0.0", port=5000, debug=False)
