import uuid
from datetime import datetime, timezone
from app.extensions import db
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import validates
from app.core.security import hash_password, verify_password
import re # used for Regular Expressions to validate complex string patterns (e.g., email format).

"""
User Data Model Definition.

Acts as the Object-Relational Mapping (ORM) for the `users` table. 
This file encapsulates the user data structure and enables the Flask application 
to manage user entities through standard Pythonic interactions (CRUD) without 
raw SQL queries.
"""

class User(db.Model):
    __tablename__ = "users"

    # Architecture Note:
    # using "uuid" for generation and "postgresql.UUID" for optimized native storage 
    # and indexing performance in PostgreSQL.
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    # core identity information
    name = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password = db.Column(db.String(255), nullable=False)

    # Role-Based Access Control (RBAC)
    system_role = db.Column(db.String(50), default="customer")
    fcm_token = db.Column(db.String(255), nullable=True) # Firebase Cloud Messaging Token
    is_active = db.Column(db.Boolean, default=True)

    # Architecture Note:
    # lambda: Ensures runtime execution (avoids fixed app-startup time).
    # timezone.utc: Modern, aware timestamps to prevent regional conflicts.
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc), nullable=False)
    deleted_at = db.Column(db.DateTime, nullable=True)

    # ==========================================
    # Validation Methods 
    # ==========================================

    # key: the name of column we try to save data into
    # value: the data itself
    
    # ----------------- validate for name -----------------
    @validates("name")
    def validate_name(self, key, value):
        """
        Sanitizes and validates the user's display name.
        Args:
            value (str): The display name provided by the user.
        Returns:
            str: The sanitized (stripped) name.

        raises:
            ValueError: if the name is missing, not a string, or not between 3-255 characters.
        """
        if not value or not isinstance(value, str):
            raise ValueError("Name is required and must be text.")
        # to removes any leading (front) or trailing (end) whitespace (spaces) from a string.
        clean_name = value.strip()
        
        if len(clean_name) < 3 or len(clean_name) > 255:
            raise ValueError("Name must be between 3 and 255 characters.")
        
        return clean_name
    
    # ----------------- validate for email -----------------
    @validates("email")
    def validate_email(self, key, value):
        """
        Normalizes and validates the email address format.
        Args:
            value (str): The raw email address provided by the user.
        Returns:
            str: The normalized (lowercase and stripped) email.

        raises:
            ValueError: if the email is missing or does not match the required regex pattern.
        """
        if not value:
            raise ValueError("Email is required.")
        
        # It ensures the email contains valid characters, an '@' symbol, a domain, and a 2-7 character extension.   
        email_regex = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,7}$"

        # Data Normalization:
        # Strips accidental spaces and converts to lowercase to prevent case-sensitivity 
        # issues in PostgreSQL. This ensures reliable logins and prevents users 
        # from creating duplicate accounts (e.g., 'User@loven.com' vs 'user@loven.com').
        clean_email = value.strip().lower()

        # validates the email against the Regex pattern.
        if not re.match(email_regex, clean_email):
            raise ValueError("Invalid email format.")
        
        return clean_email

    # ----------------- validate for role -----------------
    @validates("system_role")
    def validate_system_role(self, key, value):
        """
        Restricts the user's system role to the allowed whitelist.
        Args:
            value (str): The system role assigned to the user.
        Returns:
            str: The validated system role.

        raises:
            ValueError: if the role is not within the allowed list (customer, artist, admin).
        """
        allowed_roles = ["customer", "artist", "admin"]

        if value not in allowed_roles:
            raise ValueError(f"Invalid system role. Allowed roles are: {', '.join(allowed_roles)}")
        return value
    
    # ----------------- validate for password -----------------
    @validates("password")
    def validate_and_hash_password(self, key, value):
        """
        Validates the password strength and hashes it before storage.
        Args:
            value (str): The plain-text password provided by the user.
        Returns:
            str: the securely hashed password.

        raises:
            ValueError: if the password is missing or shorter than 8 char.
        """
        if not value:
            raise ValueError("Password is required.")
        
        # Avoid double-hashing:
        # If the value starts with the bcrypt signature '$2b$' and has sufficient length,
        # it means the password is already hashed (e.g., during a DB refresh). 
        # We return it as-is to prevent hashing a hash.
        if value.startswith(("$2a$", "$2b$", "$2y$")) and len(value) >= 50:
            return value
        
        # Password Complexity Regex:
        # (?=.*[a-z]) : At least one lowercase letter
        # (?=.*[A-Z]) : At least one uppercase letter
        # (?=.*\d)    : At least one digit (number)
        # (?=.*[\W_]) : At least one special character (non-word character or underscore)
        # .{8,}       : Minimum length of 8 characters
        password_regex = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$"
        if not re.match(password_regex, value):
            raise ValueError(
                "Password must be at least 8 characters long and include an uppercase letter, "
                "a lowercase letter, a number, and a special character."
            )
        # Encrypt the plain-text password using the security.py 
        return hash_password(value)
    
    def check_password(self, plain_password):
        """
        Verifies a plain-text password against the stored hash in the database.
        """
        if not self.password:
            return False
        
        if not self.password.startswith(("$2a$", "$2b$", "$2y$")):
            return False
        
        try:
            return verify_password(plain_password, self.password)
        except ValueError:
            return False
    
    def __repr__(self):
        return f"<User(email={self.email}, role={self.system_role})>"