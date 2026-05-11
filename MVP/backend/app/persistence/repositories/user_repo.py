"""
User repository.

Handles database operations related to the User model.
"""
from app.persistence.repository import SQLAlchemyRepository
from app.models.user import User


class UserRepository(SQLAlchemyRepository):
    def __init__(self):
        super().__init__(User)
        
    def get_user_by_email(self, email):
        """
        Fetch a user by their email address.
        """
        if not email:
            return None
        normalized_email = email.strip().lower()
        return self.model.query.filter_by(email=normalized_email).first()
    
    
    def get_user_by_id(self, user_id):
        """
        Fetch a user by their unique ID.
        Useful for the Refresh Token logic
        """
        return self.get(user_id)