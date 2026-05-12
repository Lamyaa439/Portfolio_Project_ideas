from flask import Blueprint, request, jsonify

# Architectural Change: Replaced direct auth_service imports with AuthFacade.
# Purpose: The Facade acts as an orchestrator to coordinate between
# core business logic (PostgreSQL user creation) and external services (Firebase FCM).
from app.services.facade.auth_facade import AuthFacade

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
        - fcm_token (Optional: Used for Firebase welcome notifications)

    Returns:
        JSON response with result and HTTP status code.
    """
    data = request.get_json(silent=True) or {}
    # Validate required fields BEFORE passing to service layer
    if not data.get("email") or not data.get("password"):
        return jsonify({"error": "email and password are required"}), 400

    # Delegate the payload to the Facade to handle multiple operations seamlessly:
    # 1. Persist the new user in the database via auth_service.
    # 2. Dispatch the welcome push notification via notification_service.
    result, status_code = AuthFacade.register(data)

    return jsonify(result), status_code


@auth_bp.post("/login")
def login():
    """
    Handle user login.

    Expects JSON body with:
        - email
        - password
        - fcm_token (Optional: To update the device token on login)

    Returns:
        JSON response with JWT token if successful.
    """
    # this to safely get JSON body and default to empty dict if missing or invalid
    data = request.get_json(silent=True) or {}

    # Validate required fields BEFORE authentication logic
    if not data.get("email") or not data.get("password"):
        return jsonify({"error": "email and password are required"}), 400

    # Delegate the payload to the Facade to verify credentials
    # and update the user's FCM token in the database.
    result, status_code = AuthFacade.login(data)

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
