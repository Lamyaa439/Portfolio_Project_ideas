"""
Abstract base for ORM models that share primary key and audit columns.

Subclasses set __tablename__ and their own fields. This class is not mapped
to a table (__abstract__ = True).
"""

import uuid
from datetime import datetime, timezone

from app.extensions import db
from sqlalchemy.dialects.postgresql import UUID


class BaseModel(db.Model):
    __abstract__ = True

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    created_at = db.Column(
        db.DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )
    updated_at = db.Column(
        db.DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False,
    )
    deleted_at = db.Column(
        db.DateTime(timezone=True), 
        nullable=True
        )

    def soft_delete(self):
        """Marks the record as deleted by setting the deleted_at timestamp."""
        self.deleted_at = datetime.now(timezone.utc)
        db.session.commit()

    def restore(self):
        """Restores a soft-deleted record by clearing the deleted_at field."""
        self.deleted_at = None
        db.session.commit()

    @classmethod
    def get_active(cls):
        """
        Returns a query containing only active (non-deleted) records.
        
        Args:
            cls: The specific model class calling this method (e.g., Artwork, User).
            This allows dynamic querying for whichever table inherits this model.
        """
        return cls.query.filter(cls.deleted_at.is_(None))