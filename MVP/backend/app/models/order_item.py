from app.extensions import db
from app.models.base_model import BaseModel


# =========================================================
# Model: OrderItem
# =========================================================
# Description:
# Represents a single artwork item inside an order.
#
# Relationships:
# - Belongs to one order
# - References one artwork
#
# Purpose:
# Stores individual purchased artwork items
# associated with a customer order.
#
# Inherited from BaseModel:
# - id
# - created_at
# - updated_at
# - deleted_at
# - soft_delete()
# - restore()
# =========================================================

class OrderItem(BaseModel):
    # Database table name
    __tablename__ = "order_items"

    # Reference to the parent order
    order_id = db.Column(
        db.UUID(as_uuid=True),
        db.ForeignKey("orders.id"),
        nullable=False
    )

    # Reference to the purchased artwork
    artwork_id = db.Column(
        db.UUID(as_uuid=True),
        db.ForeignKey("artworks.id"),
        nullable=False
    )

    # Quantity of artwork units purchased
    quantity = db.Column(
        db.Integer,
        nullable=False,
        default=1
    )

    # Price of the artwork at purchase time
    # Stored separately in case artwork prices change later
    price = db.Column(
        db.Numeric(10, 2),
        nullable=False
    )

    def to_dict(self):
        """
        Converts the OrderItem object into a serializable dictionary.

        Returns:
            dict: Order item data formatted for API responses.
        """
        return {
            # Convert UUID values into strings for JSON serialization
            "id": str(self.id) if self.id else None,

            # Parent order reference
            "order_id": (
                str(self.order_id)
                if self.order_id
                else None
            ),

            # Purchased artwork reference
            "artwork_id": (
                str(self.artwork_id)
                if self.artwork_id
                else None
            ),

            # Number of purchased units
            "quantity": self.quantity,

            # Convert Decimal values into float for API responses
            "price": (
                float(self.price)
                if self.price is not None
                else None
            ),

            # Audit timestamps inherited from BaseModel
            "created_at": (
                self.created_at.isoformat()
                if self.created_at
                else None
            ),
            "updated_at": (
                self.updated_at.isoformat()
                if self.updated_at
                else None
            ),
            "deleted_at": (
                self.deleted_at.isoformat()
                if self.deleted_at
                else None
            ),
        }