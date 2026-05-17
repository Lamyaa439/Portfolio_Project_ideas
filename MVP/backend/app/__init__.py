from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager

from app.api.v1.auth import auth_bp
from app.api.v1.artists_profiles import artist_profiles_bp
from app.api.v1.orders import order_bp
from app.api.v1.artworks import artwork_bp
from app.extensions import db
from config import Config

# Global JWT instance
jwt = JWTManager()


def create_app():
    app = Flask(__name__)

    # Enable CORS for API routes
    CORS(app, resources={r"/api/*": {"origins": "*"}})

    # Load application configuration
    app.config.from_object(Config)

    # Initialize database
    db.init_app(app)

    # Initialize JWT manager
    jwt.init_app(app)

    # Create database tables from SQLAlchemy models
    with app.app_context():
        from app.models.user import User
        from app.models.artist_profile import ArtistProfile
        from app.models.artwork import Artwork

        db.create_all()

    @app.route("/")
    def home():
        """
        Health check route.
        """
        return {"message": "LOVEN on Air!"}

    # =========================================================
    # Register API Blueprints
    # =========================================================

    # Authentication routes
    app.register_blueprint(auth_bp, url_prefix="/api/v1")

    # Artist profile routes
    app.register_blueprint(artist_profiles_bp, url_prefix="/api/v1")

    # Order management routes
    app.register_blueprint(order_bp, url_prefix="/api/v1/orders")

    # Artwork discovery routes
    app.register_blueprint(artwork_bp, url_prefix="/api/v1/artworks")
    
    # Print all registered routes
    print(app.url_map)

    return app
