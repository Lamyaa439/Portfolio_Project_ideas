"""
User repository.

Handles database operations related to the User model.
"""

from app.extensions import db
from app.models.user import User


def get_user_by_email(email: str):
    """
    Retrieve a user by email.
    """
    return User.query.filter_by(email=email).first()


def create_user(user_data: dict):
    """
    Create and save a new user in the database.
    """
    user = User(
        name=user_data["name"],
        email=user_data["email"],
        password=user_data["password"]  # model handles hashing
    )

    db.session.add(user)
    db.session.commit()

    return user