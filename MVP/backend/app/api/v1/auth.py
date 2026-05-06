from flask import Blueprint, request, jsonify
from app.services.facade.auth_service import register_user, login_user

# Blueprint for authentication-related routes (register, login, logout)
auth_bp = Blueprint("auth", __name__, url_prefix="/auth")


@auth_bp.post("/register")
def register():
    """
    Handle user registration.

    Expects JSON body with:
        - name
        - email
        - password

    Returns:
        JSON response with result and HTTP status code.
    """
    data = request.get_json()
    result, status_code = register_user(data)

    return jsonify(result), status_code


@auth_bp.post("/login")
def login():
    """
    Handle user login.

    Expects JSON body with:
        - email
        - password

    Returns:
        JSON response with JWT token if successful.
    """
    data = request.get_json()
    result, status_code = login_user(data)

    return jsonify(result), status_code


@auth_bp.post("/logout")
def logout():
    """
    Handle user logout.

    Note:
        For JWT-based authentication, logout is typically handled
        on the client side by removing the stored token.
    """
    return jsonify({
        "message": "Logged out successfully"
    }), 200