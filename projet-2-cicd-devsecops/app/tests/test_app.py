"""
Unit tests for the Finance App.
================================
Tests cover all API endpoints including edge cases
for a financial application (invalid amounts, insufficient balance, etc.).
"""

import json
import pytest
from app import app, accounts, transactions


@pytest.fixture(autouse=True)
def reset_state():
    """
    Reset the application state before each test.
    Ensures test isolation — each test starts with a clean state.
    """
    accounts.clear()
    accounts.update(
        {
            "ACC001": {"balance": 1000.00, "owner": "Alice Martin", "currency": "EUR"},
            "ACC002": {"balance": 2500.00, "owner": "Bob Dupont", "currency": "EUR"},
            "ACC003": {"balance": 500.00, "owner": "Charlie Durand", "currency": "EUR"},
        }
    )
    transactions.clear()
    yield


@pytest.fixture
def client():
    """Create a Flask test client."""
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


# ---------------------------------------------------------------------------
# /health endpoint tests
# ---------------------------------------------------------------------------


class TestHealth:
    """Tests for the /health endpoint."""

    def test_health(self, client):
        """GET /health should return 200 with status 'healthy'."""
        response = client.get("/health")
        data = json.loads(response.data)

        assert response.status_code == 200
        assert data["status"] == "healthy"
        assert data["version"] == "1.0.0"
        assert data["service"] == "finance-app"
        assert "timestamp" in data
        assert data["accounts_count"] == 3

    def test_health_method_not_allowed(self, client):
        """POST /health should return 405 Method Not Allowed."""
        response = client.post("/health")
        assert response.status_code == 405


# ---------------------------------------------------------------------------
# /api/transactions endpoint tests
# ---------------------------------------------------------------------------


class TestTransactions:
    """Tests for the /api/transactions endpoint."""

    def test_get_transactions_empty(self, client):
        """GET /api/transactions should return empty list initially."""
        response = client.get("/api/transactions")
        data = json.loads(response.data)

        assert response.status_code == 200
        assert data["transactions"] == []
        assert data["count"] == 0

    def test_create_transaction(self, client):
        """POST /api/transactions should create a transaction record."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 150.00,
            "type": "transfer",
        }
        response = client.post(
            "/api/transactions",
            data=json.dumps(payload),
            content_type="application/json",
        )
        data = json.loads(response.data)

        assert response.status_code == 201
        assert data["message"] == "Transaction created successfully"
        assert data["transaction"]["from_account"] == "ACC001"
        assert data["transaction"]["to_account"] == "ACC002"
        assert data["transaction"]["amount"] == 150.00
        assert data["transaction"]["status"] == "completed"
        assert data["transaction"]["id"].startswith("txn_")

    def test_get_transactions_after_create(self, client):
        """GET /api/transactions should return created transactions."""
        # Create a transaction first
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 50.00,
        }
        client.post(
            "/api/transactions",
            data=json.dumps(payload),
            content_type="application/json",
        )

        # Retrieve transactions
        response = client.get("/api/transactions")
        data = json.loads(response.data)

        assert response.status_code == 200
        assert data["count"] == 1
        assert data["transactions"][0]["amount"] == 50.00

    def test_get_transactions_filter_by_account(self, client):
        """GET /api/transactions?account_id=X should filter results."""
        # Create two transactions
        client.post(
            "/api/transactions",
            data=json.dumps(
                {"from_account": "ACC001", "to_account": "ACC002", "amount": 50}
            ),
            content_type="application/json",
        )
        client.post(
            "/api/transactions",
            data=json.dumps(
                {"from_account": "ACC003", "to_account": "ACC002", "amount": 75}
            ),
            content_type="application/json",
        )

        # Filter by ACC001 — should get 1 transaction
        response = client.get("/api/transactions?account_id=ACC001")
        data = json.loads(response.data)
        assert data["count"] == 1

        # Filter by ACC002 — should get 2 transactions (both involve ACC002)
        response = client.get("/api/transactions?account_id=ACC002")
        data = json.loads(response.data)
        assert data["count"] == 2

    def test_create_transaction_missing_field(self, client):
        """POST /api/transactions without required fields should return 400."""
        payload = {"from_account": "ACC001"}  # Missing to_account and amount
        response = client.post(
            "/api/transactions",
            data=json.dumps(payload),
            content_type="application/json",
        )
        data = json.loads(response.data)

        assert response.status_code == 400
        assert "Missing required field" in data["error"]

    def test_create_transaction_invalid_json(self, client):
        """POST /api/transactions with invalid body should return 400."""
        response = client.post(
            "/api/transactions",
            data="not json",
            content_type="text/plain",
        )

        assert response.status_code == 400

    def test_create_transaction_account_not_found(self, client):
        """POST /api/transactions with unknown account should return 404."""
        payload = {
            "from_account": "ACC999",
            "to_account": "ACC002",
            "amount": 50.00,
        }
        response = client.post(
            "/api/transactions",
            data=json.dumps(payload),
            content_type="application/json",
        )

        assert response.status_code == 404


# ---------------------------------------------------------------------------
# /api/balance endpoint tests
# ---------------------------------------------------------------------------


class TestBalance:
    """Tests for the /api/balance endpoint."""

    def test_get_balance(self, client):
        """GET /api/balance?account_id=ACC001 should return the correct balance."""
        response = client.get("/api/balance?account_id=ACC001")
        data = json.loads(response.data)

        assert response.status_code == 200
        assert data["account_id"] == "ACC001"
        assert data["balance"] == 1000.00
        assert data["currency"] == "EUR"
        assert data["owner"] == "Alice Martin"

    def test_get_balance_missing_account_id(self, client):
        """GET /api/balance without account_id should return 400."""
        response = client.get("/api/balance")
        data = json.loads(response.data)

        assert response.status_code == 400
        assert "account_id" in data["error"]

    def test_get_balance_account_not_found(self, client):
        """GET /api/balance with unknown account should return 404."""
        response = client.get("/api/balance?account_id=ACC999")

        assert response.status_code == 404


# ---------------------------------------------------------------------------
# /api/transfer endpoint tests
# ---------------------------------------------------------------------------


class TestTransfer:
    """Tests for the /api/transfer endpoint."""

    def test_transfer(self, client):
        """POST /api/transfer should move funds between accounts."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 200.00,
        }
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )
        data = json.loads(response.data)

        assert response.status_code == 200
        assert data["message"] == "Transfer completed successfully"
        assert data["transfer"]["amount"] == 200.00
        assert data["transfer"]["from_balance"] == 800.00  # 1000 - 200
        assert data["transfer"]["to_balance"] == 2700.00  # 2500 + 200

    def test_transfer_updates_balance(self, client):
        """After a transfer, balances should be updated correctly."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 300.00,
        }
        client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )

        # Check sender balance
        response = client.get("/api/balance?account_id=ACC001")
        data = json.loads(response.data)
        assert data["balance"] == 700.00  # 1000 - 300

        # Check receiver balance
        response = client.get("/api/balance?account_id=ACC002")
        data = json.loads(response.data)
        assert data["balance"] == 2800.00  # 2500 + 300

    def test_invalid_transfer_negative_amount(self, client):
        """POST /api/transfer with negative amount should return 400."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": -100.00,
        }
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )
        data = json.loads(response.data)

        assert response.status_code == 400
        assert "positive" in data["error"].lower() or "Amount" in data["error"]

    def test_invalid_transfer_zero_amount(self, client):
        """POST /api/transfer with zero amount should return 400."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 0,
        }
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )

        assert response.status_code == 400

    def test_insufficient_balance(self, client):
        """POST /api/transfer exceeding balance should return 400."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 5000.00,  # ACC001 only has 1000
        }
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )
        data = json.loads(response.data)

        assert response.status_code == 400
        assert data["error"] == "Insufficient balance"
        assert data["available_balance"] == 1000.00
        assert data["requested_amount"] == 5000.00

    def test_transfer_same_account(self, client):
        """POST /api/transfer to same account should return 400."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC001",
            "amount": 100.00,
        }
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )

        assert response.status_code == 400
        assert "same account" in json.loads(response.data)["error"].lower()

    def test_transfer_account_not_found(self, client):
        """POST /api/transfer with unknown account should return 404."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC999",
            "amount": 100.00,
        }
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )

        assert response.status_code == 404

    def test_transfer_missing_field(self, client):
        """POST /api/transfer without required fields should return 400."""
        payload = {"from_account": "ACC001"}
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )

        assert response.status_code == 400

    def test_transfer_exceeds_maximum(self, client):
        """POST /api/transfer exceeding max amount should return 400."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 2_000_000,  # Exceeds 1,000,000 limit
        }
        response = client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )

        assert response.status_code == 400
        assert "maximum" in json.loads(response.data)["error"].lower()

    def test_transfer_creates_transaction_record(self, client):
        """A successful transfer should appear in the transactions list."""
        payload = {
            "from_account": "ACC001",
            "to_account": "ACC002",
            "amount": 100.00,
        }
        client.post(
            "/api/transfer",
            data=json.dumps(payload),
            content_type="application/json",
        )

        response = client.get("/api/transactions")
        data = json.loads(response.data)

        assert data["count"] == 1
        assert data["transactions"][0]["type"] == "transfer"
        assert data["transactions"][0]["amount"] == 100.00


# ---------------------------------------------------------------------------
# /metrics endpoint tests
# ---------------------------------------------------------------------------


class TestMetrics:
    """Tests for the /metrics endpoint."""

    def test_metrics_endpoint(self, client):
        """GET /metrics should return Prometheus-format metrics."""
        response = client.get("/metrics")

        assert response.status_code == 200
        # Prometheus metrics are returned as text
        assert b"finance_app" in response.data


# ---------------------------------------------------------------------------
# 404 error handler tests
# ---------------------------------------------------------------------------


class TestErrorHandlers:
    """Tests for error handling."""

    def test_404_handler(self, client):
        """Accessing unknown route should return 404 with JSON error."""
        response = client.get("/nonexistent")
        data = json.loads(response.data)

        assert response.status_code == 404
        assert data["error"] == "Resource not found"
