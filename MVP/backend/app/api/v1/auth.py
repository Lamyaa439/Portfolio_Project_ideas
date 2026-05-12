from flask import Blueprint, request, jsonify
from app.services.facade.auth_facade import AuthFacade
from app.persistence.repositories.user_repo import UserRepository
from flask_jwt_extended import jwt_required, get_jwt_identity


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
    data = request.get_json()

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
    data = request.get_json()
    # Delegate the payload to the Facade to verify credentials
    # and update the user's FCM token in the database.
    result, status_code = AuthFacade.login(data)
    return jsonify(result), status_code


@auth_bp.post("/logout")
@jwt_required() # 1. Security guard: Requires a valid JWT in the request header to access this route.
def logout():
    """
    Handle user logout.
    Clears the FCM token from the database to prevent cross-account notifications.
    """
    # 2. Extract the current user's ID from the validated JWT.
    current_user_id = get_jwt_identity()

    # 3. Instantiate the user repository for database operations.
    user_repo = UserRepository()

    # 4. Clear the FCM token (set to None) to stop push notifications to this specific device.
    user_repo.update_fcm_token(current_user_id, None)

    return jsonify({
        "message": "Logged out successfully and notifications disabled for this device."
    }), 200