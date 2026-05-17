from flask import Flask
from app.api.v1.auth import auth_bp
from app.api.v1.carts import carts_bp
from app.api.v1.orders import order_bp
from app.extensions import db
from config import Config
from flask_cors import CORS
from flask_jwt_extended import JWTManager

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
        from app.models.cart import Cart
        from app.models.cart_item import CartItem

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

    # Shopping cart routes
    app.register_blueprint(carts_bp, url_prefix="/api/v1")

    # Order management routes
    app.register_blueprint(order_bp, url_prefix="/api/v1/orders")

    # Print all registered routes
    print(app.url_map)

    return app