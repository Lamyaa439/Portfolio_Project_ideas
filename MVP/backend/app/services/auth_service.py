"""
Authentication service layer.

This module defines the business logic for user registration and login.
It connects the API layer with the persistence layer and security utilities.
"""

from app.persistence.repositories.user_repo import UserRepository
from app.models.user import User
from app.core.security import create_access_token, create_refresh_token

user_repo = UserRepository()

def register_user(data):
    """
    Register a new user.
    Args:
        data : Request data containing:
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
    fcm_token = data.get("fcm_token")
    role = data.get("system_role","customer").lower()

    # Validate required fields
    if not name or not email or not password:
        return {"error": "Missing required fields"}, 400
    
    # Role Check
    allowed_roles = ["customer", "artist"]
    if role not in allowed_roles:
        return {"error": f"Invalid registration role. Allowed roles are: {', '.join(allowed_roles)}"}, 400

    # Check if a user with the same email already exists
    if user_repo.get_user_by_email(email):
        return {"error": "User already exists"}, 400
    
    try:
        # Create the User object
        new_user = User(
        name = name,
        email = email,
        password = password,
        fcm_token = fcm_token,
        system_role = role
        )

        # Save to database securely using our Generic Repository 
        user_repo.add(new_user)
        
        # Generate JWT access token using user ID
        token = create_access_token({
            "user_id": str(new_user.id),
            "role": new_user.system_role
            })
        
        return {
            "message": "User registered successfully",
            "access_token": token
        }, 201
    except ValueError as e:
        # Catching validation errors cleanly
        return {"error": str(e)}, 400
    except Exception as e:
        return {"error": "An internal error occurred during registration"}, 500


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
    fcm_token = data.get("fcm_token")

    # Validate required fields
    if not email or not password:
        return {"error": "Missing email or password"}, 400
    
    # Retrieve user from database
    user = user_repo.get_user_by_email(email)

    # Validate credentials
    if not user or not user.check_password(password):
        return {"error": "Invalid email or password"}, 401
    
    # UPDATE FCM TOKEN ON LOGIN
    if fcm_token:
        user_repo.update_fcm_token(user.id, fcm_token)

    # Generate JWT access token
    token = create_access_token({
        "user_id": str(user.id),
        "role": user.system_role
    })

    return {
        "message": "Login successful",
        "access_token": token
    }, 200