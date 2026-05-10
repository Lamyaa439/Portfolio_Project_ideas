"""
Security utilities for authentication.

This module contains helper functions for:
- Hashing user passwords using bcrypt.
- Verifying plain passwords against hashed passwords.
- Creating JWT access tokens for authenticated users.
- Decoding and validating JWT access tokens.

These functions are used by the authentication routes and services.
"""

from datetime import datetime, timedelta, timezone
from jose import jwt, JWTError, ExpiredSignatureError
from passlib.context import CryptContext
import os
from dotenv import load_dotenv

# Ensure environment variables are loaded before reading them
load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key")
ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))
REFRESH_TOKEN_EXPIRE_DAYS = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", 7))

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    """
    Hash a plain-text password using bcrypt.

    Args:
        password (str): The plain-text password entered by the user.

    Returns:
        str: The hashed password that can be safely stored in the database.
    """
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verify whether a plain-text password matches a hashed password.

    Args:
        plain_password (str): The password entered by the user.
        hashed_password (str): The hashed password stored in the database.

    Returns:
        bool: True if the password matches, otherwise False.
    """
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict) -> str:
    """
    Create a JWT access token with an expiration time.

    Args:
        data (dict): The payload data to include in the token, such as user ID or email.

    Returns:
        str: Encoded JWT access token.
    """
    if "user_id" not in data or "role" not in data:
        raise ValueError("Missing required claims: 'user_id' or 'role'")
    
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    # set expiration, user identity, and RBAC role for the access token.
    to_encode.update({
        "exp": expire,
        "sub": str(data["user_id"]),
        "role": data["role"]
        })

    token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return token

def create_refresh_token(data: dict) -> str:
    """
    Create a long-lived JWT refresh token.
    """
    if "user_id" not in data:
        raise ValueError("Missing required claim: 'user_id'")
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)

    to_encode.update({
        "exp": expire,
        "sub": str(data["user_id"]),
        "type": "refresh"
    })

    token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return token


def decode_access_token(token: str):
    """
    Decodes a JWT access token and returns its payload or a specific error state.

    Args:
        token (str): The client's JWT access token.

    Returns:
        dict: The decoded payload on success, or an error payload on failure.
    """
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except ExpiredSignatureError:
        return {"error": "Token has expired"}
    except JWTError:
        return {"error": "Invalid token"}