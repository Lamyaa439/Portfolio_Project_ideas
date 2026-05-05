"""
Authentication service layer.

This module defines the business logic for user registration and login.
It connects the API layer with the persistence layer and security utilities.
"""

from app.persistence.repositories.user_repo import get_user_by_email, create_user
from app.core.security import create_access_token


def register_user(data: dict):
    """
    Register a new user.

    Args:
        data (dict): Request data containing:
            - name (str)
            - email (str)
            - password (str)

    Returns:
        tuple: JSON response and HTTP status code.
    """
    # Extract user input from request body
    name = data.get("name")
    email = data.get("email")
    password = data.get("password")

    # Validate required fields
    if not name or not email or not password:
        return {"error": "Missing required fields"}, 400

    # Check if a user with the same email already exists
    existing_user = get_user_by_email(email)
    if existing_user:
        return {"error": "User already exists"}, 400

    # Create a new user (password hashing handled in model)
    user = create_user({
        "name": name,
        "email": email,
        "password": password
    })

    # Generate JWT access token using user ID
    token = create_access_token({"sub": str(user.id)})

    return {
        "message": "User registered successfully",
        "access_token": token
    }, 201


def login_user(data: dict):
    """
    Authenticate a user and return an access token.

    Args:
        data (dict): Request data containing:
            - email (str)
            - password (str)

    Returns:
        tuple: JSON response and HTTP status code.
    """
    # Extract login credentials
    email = data.get("email")
    password = data.get("password")

    # Validate required fields
    if not email or not password:
        return {"error": "Missing email or password"}, 400

    # Normalize email to match stored format (lowercase, trimmed)
    email = email.strip().lower()

    # Retrieve user from database
    user = get_user_by_email(email)

    # Validate credentials
    if not user or not user.check_password(password):
        return {"error": "Invalid credentials"}, 401

    # Generate JWT access token
    token = create_access_token({"sub": str(user.id)})

    return {
        "message": "Login successful",
        "access_token": token
    }, 200