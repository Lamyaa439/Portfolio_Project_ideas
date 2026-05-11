"""
User repository.

Handles database operations related to the User model.
"""

from app.extensions import db
from app.models.user import User
from sqlalchemy.exc import IntegrityError


def get_user_by_email(email: str):
    """
    Retrieve a user by email.
    """
    normalized_email = email.strip().lower() if email else None
    return User.query.filter_by(email=normalized_email).first()


def get_user_by_id(id):
    """
    Retrieve a user by ID
    """ 
    return 

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