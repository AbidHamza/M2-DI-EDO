from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine, Base
from app.routes import auth, books, loans

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Library Management API",
    description="API REST pour la gestion d'une bibliothèque",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En production, spécifier les origines autorisées
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(books.router, prefix="/api/books", tags=["Books"])
app.include_router(loans.router, prefix="/api/loans", tags=["Loans"])


@app.get("/")
def root():
    return {"message": "Welcome to Library Management API", "docs": "/docs"}


@app.get("/api/health")
def health_check():
    return {"status": "OK", "message": "API is running"}


