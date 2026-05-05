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
from jose import jwt, JWTError
from passlib.context import CryptContext
import os
from dotenv import load_dotenv

# Ensure environment variables are loaded before reading them
load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key")
ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))

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
    to_encode = data.copy()

    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})

    token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return token


def decode_access_token(token: str):
    """
    Decode and validate a JWT access token.

    Args:
        token (str): The JWT access token sent by the client.

    Returns:
        dict | None: The decoded token payload if valid, otherwise None.
    """
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None