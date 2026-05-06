from flask import Flask
from app.api.v1.auth import auth_bp
from app.extensions import db
from config import Config

def create_app():
    app = Flask(__name__)

    # Load application configuration from the Config class (including SECRET_KEY)
    app.config.from_object(Config)

    # Initialize the database instance with the application context
    db.init_app(app)

    # Create database tables from SQLAlchemy models
    with app.app_context():
        from app.models.user import User
        db.create_all()

    @app.route("/")
    def home():
        return {"message": "LOVEN on Air!"}

    app.register_blueprint(auth_bp, url_prefix='/api/v1')

    return app