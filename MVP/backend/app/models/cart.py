"""
Cart Data Model Definition.

ORM for the `carts` table. Each customer has at most one cart (one-to-one with User).
Line items live in `cart_items` (see cart_item.py).
"""

from app.extensions import db
from app.models.base_model import BaseModel
from sqlalchemy.dialects.postgresql import UUID


class Cart(BaseModel):
    __tablename__ = "carts"

    # One cart per user (UNIQUE in SQL schema).
    # ON DELETE CASCADE: removing the user removes their cart.
    user_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey("users.id", ondelete="CASCADE"),
        unique=True,
        nullable=False,
        index=True,
    )

    # Connects the cart to its items (One-to-Many).
    # 'dynamic' allows smart searching and sorting of items inside the cart.
    # 'delete-orphan' automatically deletes any item removed from the cart.
    items = db.relationship(
        "CartItem",
        # Back Reference
        backref=db.backref("cart", lazy=True), # ربط المنتجات بالسلة وربط السلة بالمنتجات
        lazy="dynamic",
        cascade="all, delete-orphan",
    )

    # Connect the cart to user (One-to-One).
    user = db.relationship(
        "User",
        backref=db.backref("cart", uselist=False),
    )

    def to_dict(self):
        """
        Converts the cart object into a JSON-friendly dictionary for API responses.
        Handles the conversion of UUIDs to strings and dates to ISO format.
        """
        return {
            "id": str(self.id) if self.id else None,
            "user_id": str(self.user_id) if self.user_id else None,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
            "deleted_at": self.deleted_at.isoformat() if self.deleted_at else None,
        }

    def __repr__(self):
        return f"<Cart(user_id={self.user_id})>"
