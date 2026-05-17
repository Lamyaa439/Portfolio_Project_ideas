"""
CartItem Data Model Definition.

ORM for the `cart_items` table. Each row is one artwork line inside a cart.
"""

from app.extensions import db
from app.models.base_model import BaseModel
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import validates


class CartItem(BaseModel):
    __tablename__ = "cart_items"

    cart_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey("carts.id", ondelete="CASCADE"), # إذا حُذفت السلة نحذف جميع المنتجات داخلها
        nullable=False,
        index=True,
    )

    # Connects the item with artwork
    artwork_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey("artworks.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    quantity = db.Column(db.Integer, nullable=False, default=1)

    # Links the cart item to its specific artwork (Many-to-One).
    artwork = db.relationship(
        "Artwork",
        backref=db.backref("cart_items", lazy="dynamic"),
    )

    # ==========================================
    # Validation
    # ==========================================

    @validates("quantity")
    def validate_quantity(self, key, value):
        """
        Validates the quantity field before saving to the database.
        Ensures the value is a positive whole number (Integer >= 1).
        If the value is missing, it defaults to 1.
        """
        if value is None:
            return 1

        try:
            quantity = int(value)
        except (TypeError, ValueError):
            raise ValueError("Quantity must be a whole number.")

        if quantity < 1:
            raise ValueError("Quantity must be at least 1.")

        return quantity

    def to_dict(self):
        """Serialize the cart line item for API responses."""
        return {
            "id": str(self.id) if self.id else None,
            "cart_id": str(self.cart_id) if self.cart_id else None,
            "artwork_id": str(self.artwork_id) if self.artwork_id else None,
            "quantity": self.quantity,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
            "deleted_at": self.deleted_at.isoformat() if self.deleted_at else None,
        }

    def __repr__(self):
        return (
            f"<CartItem(cart_id={self.cart_id}, "
            f"artwork_id={self.artwork_id}, quantity={self.quantity})>"
        )
