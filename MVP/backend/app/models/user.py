import uuid
from datetime import datetime, timezone
from app.extensions import db
from sqlalchemy.dialects.postgresql import UUID

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
    name = db.Column(db.String(255))
    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255))

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

    def __repr__(self):
        return f"<User(email={self.email}, role={self.system_role})>"