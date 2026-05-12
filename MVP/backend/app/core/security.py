"""
Security utilities for authentication.

This module contains helper functions for:
- Hashing user passwords using bcrypt.
- Verifying plain passwords against hashed passwords.

Note: JWT operations are now handled directly via 'flask-jwt-extended'.
"""

from passlib.context import CryptContext

# Configuration for bcrypt password hashing
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