# Exercice Phase 5 : Authentification JWT Complète

## 📝 Exercice à réaliser

Implémentez un système d'authentification complet avec :
1. Hachage de mot de passe avec bcrypt
2. Génération et vérification de JWT
3. Service d'authentification
4. Middleware de protection des routes
5. Routes d'inscription, connexion et profil

## 🎯 Objectifs pédagogiques

- Comprendre le hachage de mot de passe
- Maîtriser JWT (génération et vérification)
- Implémenter l'injection de dépendances FastAPI
- Protéger les routes avec authentification
- Gérer les erreurs d'authentification

## ✅ Correction complète

```python
"""
Exercice Phase 5 : Authentification JWT Complète
Implémentation complète d'un système d'authentification
"""

from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel, EmailStr
from sqlalchemy import create_engine, Column, Integer, String, Boolean, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.sql import func

# ============================================
# 1. CONFIGURATION
# ============================================

# Configuration JWT
SECRET_KEY = "your-secret-key-change-in-production"  # ⚠️ Changez en production !
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Base de données (simplifiée pour l'exercice)
DATABASE_URL = "sqlite:///./test_auth.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

# CryptContext pour bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# HTTPBearer pour extraire le token
security = HTTPBearer()


# ============================================
# 2. MODÈLE USER (SQLAlchemy)
# ============================================

class User(Base):
    """Modèle utilisateur pour la base de données."""
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True, nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


# Créer les tables
Base.metadata.create_all(bind=engine)


# ============================================
# 3. SCHÉMAS PYDANTIC
# ============================================

class UserCreate(BaseModel):
    """Schéma pour créer un utilisateur."""
    username: str
    email: EmailStr
    password: str


class UserLogin(BaseModel):
    """Schéma pour la connexion."""
    email: EmailStr
    password: str


class UserResponse(BaseModel):
    """Schéma de réponse utilisateur (sans mot de passe)."""
    id: int
    username: str
    email: str
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True


class Token(BaseModel):
    """Schéma de réponse avec token."""
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


# ============================================
# 4. SERVICE D'AUTHENTIFICATION
# ============================================

class AuthService:
    """
    Service gérant toutes les opérations d'authentification.
    """
    
    @staticmethod
    def hash_password(password: str) -> str:
        """
        Hash un mot de passe avec bcrypt.
        
        Args:
            password: Mot de passe en clair
            
        Returns:
            str: Mot de passe hashé
        """
        return pwd_context.hash(password)
    
    @staticmethod
    def verify_password(plain_password: str, hashed_password: str) -> bool:
        """
        Vérifie qu'un mot de passe correspond au hash.
        
        Args:
            plain_password: Mot de passe en clair
            hashed_password: Mot de passe hashé
            
        Returns:
            bool: True si le mot de passe correspond
        """
        return pwd_context.verify(plain_password, hashed_password)
    
    @staticmethod
    def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
        """
        Crée un token JWT.
        
        Args:
            data: Données à inclure dans le token (ex: {"sub": user_id})
            expires_delta: Durée de vie du token (optionnel)
            
        Returns:
            str: Token JWT encodé
        """
        to_encode = data.copy()
        
        # Ajouter l'expiration
        if expires_delta:
            expire = datetime.utcnow() + expires_delta
        else:
            expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        
        to_encode.update({"exp": expire})
        
        # Encoder le token
        encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
        return encoded_jwt
    
    @staticmethod
    def verify_token(token: str) -> Optional[dict]:
        """
        Vérifie et décode un token JWT.
        
        Args:
            token: Token JWT à vérifier
            
        Returns:
            dict: Payload du token si valide, None sinon
        """
        try:
            payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
            return payload
        except JWTError:
            return None


# ============================================
# 5. MIDDLEWARE D'AUTHENTIFICATION
# ============================================

def get_db():
    """
    Dependency pour obtenir une session de base de données.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    """
    Dependency pour obtenir l'utilisateur actuel depuis le token JWT.
    
    Args:
        credentials: Credentials HTTP (contient le token)
        db: Session de base de données
        
    Returns:
        User: Utilisateur actuel
        
    Raises:
        HTTPException: Si le token est invalide ou l'utilisateur non trouvé
    """
    token = credentials.credentials
    
    # Vérifier le token
    payload = AuthService.verify_token(token)
    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token invalide ou expiré",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Extraire l'ID utilisateur
    user_id: str = payload.get("sub")
    if user_id is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token invalide",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Récupérer l'utilisateur
    user = db.query(User).filter(User.id == int(user_id)).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Utilisateur non trouvé",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    return user


# ============================================
# 6. APPLICATION FASTAPI
# ============================================

app = FastAPI(title="Exercice Authentification JWT")


# ============================================
# 7. ROUTES D'AUTHENTIFICATION
# ============================================

@app.post("/auth/register", response_model=Token, status_code=status.HTTP_201_CREATED)
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    """
    Inscription d'un nouvel utilisateur.
    
    Args:
        user_data: Données de l'utilisateur à créer
        db: Session de base de données
        
    Returns:
        Token: Token JWT et informations utilisateur
        
    Raises:
        HTTPException: Si l'utilisateur existe déjà
    """
    # Vérifier si l'utilisateur existe déjà
    existing_user = db.query(User).filter(
        (User.email == user_data.email) | (User.username == user_data.username)
    ).first()
    
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email ou username déjà utilisé"
        )
    
    # Créer le nouvel utilisateur
    hashed_password = AuthService.hash_password(user_data.password)
    new_user = User(
        username=user_data.username,
        email=user_data.email,
        hashed_password=hashed_password
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    # Générer le token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = AuthService.create_access_token(
        data={"sub": str(new_user.id)},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": new_user
    }


@app.post("/auth/login", response_model=Token)
def login(credentials: UserLogin, db: Session = Depends(get_db)):
    """
    Connexion d'un utilisateur existant.
    
    Args:
        credentials: Email et mot de passe
        db: Session de base de données
        
    Returns:
        Token: Token JWT et informations utilisateur
        
    Raises:
        HTTPException: Si les identifiants sont incorrects
    """
    # Trouver l'utilisateur
    user = db.query(User).filter(User.email == credentials.email).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Vérifier le mot de passe
    if not AuthService.verify_password(credentials.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Vérifier que l'utilisateur est actif
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Compte utilisateur désactivé"
        )
    
    # Générer le token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = AuthService.create_access_token(
        data={"sub": str(user.id)},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user
    }


@app.get("/auth/me", response_model=UserResponse)
def get_current_user_info(current_user: User = Depends(get_current_user)):
    """
    Récupère les informations de l'utilisateur connecté.
    Route protégée nécessitant un token JWT valide.
    
    Args:
        current_user: Utilisateur actuel (injecté par Depends)
        
    Returns:
        UserResponse: Informations de l'utilisateur
    """
    return current_user


@app.get("/auth/protected")
def protected_route(current_user: User = Depends(get_current_user)):
    """
    Exemple de route protégée.
    Seuls les utilisateurs authentifiés peuvent y accéder.
    """
    return {
        "message": f"Bienvenue {current_user.username} !",
        "user_id": current_user.id
    }


# ============================================
# 8. TESTS
# ============================================

def test_auth_flow():
    """
    Teste le flux d'authentification complet.
    """
    print("=" * 60)
    print("TEST DU FLUX D'AUTHENTIFICATION")
    print("=" * 60)
    
    db = SessionLocal()
    
    try:
        # Test 1 : Hash de mot de passe
        print("\n1️⃣ Test : Hash de mot de passe")
        password = "monMotDePasse123"
        hashed = AuthService.hash_password(password)
        print(f"   Mot de passe original: {password}")
        print(f"   Hash: {hashed[:50]}...")
        
        # Test 2 : Vérification de mot de passe
        print("\n2️⃣ Test : Vérification de mot de passe")
        is_valid = AuthService.verify_password(password, hashed)
        print(f"   Mot de passe valide: {is_valid}")
        
        is_invalid = AuthService.verify_password("mauvaisMotDePasse", hashed)
        print(f"   Mauvais mot de passe: {is_invalid}")
        
        # Test 3 : Génération de token
        print("\n3️⃣ Test : Génération de token JWT")
        token = AuthService.create_access_token(data={"sub": "123"})
        print(f"   Token généré: {token[:50]}...")
        
        # Test 4 : Vérification de token
        print("\n4️⃣ Test : Vérification de token")
        payload = AuthService.verify_token(token)
        if payload:
            print(f"   ✅ Token valide")
            print(f"   User ID: {payload.get('sub')}")
        else:
            print(f"   ❌ Token invalide")
        
        # Test 5 : Token expiré
        print("\n5️⃣ Test : Token expiré")
        expired_token = AuthService.create_access_token(
            data={"sub": "123"},
            expires_delta=timedelta(seconds=-1)  # Expiré immédiatement
        )
        payload = AuthService.verify_token(expired_token)
        if payload is None:
            print(f"   ✅ Token expiré correctement détecté")
        
        print("\n" + "=" * 60)
        print("✅ TOUS LES TESTS RÉUSSIS")
        print("=" * 60)
        
    finally:
        db.close()


if __name__ == "__main__":
    # Exécuter les tests
    test_auth_flow()
    
    # Démarrer le serveur
    print("\n🚀 Serveur démarré sur http://localhost:8000")
    print("📖 Documentation: http://localhost:8000/docs")
    print("\nPour démarrer: uvicorn exercice_phase5:app --reload")
```

## 📚 Explications détaillées

### 1. Hachage de mot de passe

```python
hashed = pwd_context.hash(password)
```

**Explication :**
- **bcrypt** : Algorithme de hachage avec salt automatique
- **10 rounds** : Nombre d'itérations (défaut, bon compromis sécurité/performance)
- **Salt** : Ajouté automatiquement, différent à chaque hash
- **Irréversible** : Impossible de retrouver le mot de passe original

### 2. Vérification de mot de passe

```python
is_valid = pwd_context.verify(plain_password, hashed_password)
```

**Explication :**
- Compare le mot de passe en clair avec le hash
- Extrait le salt du hash automatiquement
- Retourne True/False

### 3. Génération de JWT

```python
token = jwt.encode(
    {"sub": user_id, "exp": expire},
    SECRET_KEY,
    algorithm="HS256"
)
```

**Explication :**
- **sub** : Subject (ID utilisateur)
- **exp** : Expiration (timestamp Unix)
- **SECRET_KEY** : Clé secrète pour signer
- **HS256** : Algorithme de signature

### 4. Vérification de JWT

```python
payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
```

**Explication :**
- Vérifie la signature
- Vérifie l'expiration
- Retourne le payload ou lève une exception

### 5. Dependency Injection

```python
def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
```

**Explication :**
- **Depends()** : Injection de dépendances FastAPI
- **HTTPBearer** : Extrait automatiquement le token du header
- **Réutilisable** : Utilisable dans toutes les routes protégées

### 6. Utilisation dans les routes

```python
@app.get("/protected")
def protected_route(current_user: User = Depends(get_current_user)):
    # current_user est automatiquement injecté
    return {"user": current_user.username}
```

**Explication :**
- FastAPI appelle automatiquement `get_current_user`
- Si le token est invalide, une exception 401 est levée
- Sinon, `current_user` contient l'utilisateur

## 🧪 Comment tester

1. **Démarrer le serveur :**
   ```bash
   uvicorn exercice_phase5:app --reload
   ```

2. **Tester avec Swagger :**
   - Ouvrez `http://localhost:8000/docs`
   - Testez `/auth/register`
   - Testez `/auth/login`
   - Copiez le token
   - Cliquez sur "Authorize"
   - Entrez : `Bearer VOTRE_TOKEN`
   - Testez `/auth/me`

3. **Tester avec curl :**
   ```bash
   # Inscription
   curl -X POST http://localhost:8000/auth/register \
     -H "Content-Type: application/json" \
     -d '{"username":"test","email":"test@test.com","password":"test123"}'
   
   # Connexion
   curl -X POST http://localhost:8000/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test@test.com","password":"test123"}'
   
   # Route protégée
   curl http://localhost:8000/auth/me \
     -H "Authorization: Bearer VOTRE_TOKEN"
   ```

## 🎓 Points clés à retenir

1. **Jamais en clair** : Toujours hasher les mots de passe
2. **SECRET_KEY forte** : Utilisez une clé aléatoire et longue
3. **Expiration** : Configurez une expiration raisonnable
4. **Dependency Injection** : Utilisez Depends() pour réutiliser
5. **Gestion d'erreurs** : Retournez des codes HTTP appropriés

## 🐛 Erreurs courantes

- **"Invalid token"** : Vérifiez SECRET_KEY et le format
- **"Token expired"** : Le token a expiré, reconnectez-vous
- **"User not found"** : L'ID dans le token ne correspond à aucun utilisateur

## ✅ Checklist de validation

- [ ] Les mots de passe sont hashés
- [ ] La vérification de mot de passe fonctionne
- [ ] Les tokens JWT sont générés correctement
- [ ] La vérification de token fonctionne
- [ ] L'inscription fonctionne
- [ ] La connexion fonctionne
- [ ] Les routes protégées fonctionnent
- [ ] Les erreurs sont gérées proprement

---

**Parfait ! Vous maîtrisez maintenant l'authentification JWT ! 🎉**

