from flask import Flask
from app.api.v1.auth import auth_bp


def create_app():
    app = Flask(__name__)

    @app.route("/")
    def home():
        return {"message": "LOVEN on Air!"}

    app.register_blueprint(auth_bp)

    return app