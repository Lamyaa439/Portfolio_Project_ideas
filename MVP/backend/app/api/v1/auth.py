from flask import Blueprint, request, jsonify

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")


@auth_bp.post("/register")
def register():
    data = request.get_json()

    # TODO: validate name, email, password
    # TODO: call auth_service.register_user(data)
    # TODO: return user object + token

    return jsonify({
        "message": "Register endpoint ready",
        "todo": "Connect to User model and auth_service"
    }), 501


@auth_bp.post("/login")
def login():
    data = request.get_json()

    # TODO: validate email and password
    # TODO: call auth_service.login_user(data)
    # TODO: verify password and return JWT token

    return jsonify({
        "message": "Login endpoint ready",
        "todo": "Connect to User model and auth_service"
    }), 501


@auth_bp.post("/logout")
def logout():
    # For JWT, logout is usually handled on frontend by deleting token.
    # TODO: add token blacklist later.

    return jsonify({
        "message": "Logged out successfully"
    }), 200