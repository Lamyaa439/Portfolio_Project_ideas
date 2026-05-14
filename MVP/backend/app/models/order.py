from app.extensions import db
from app.models.base_model import BaseModel


# =========================================================
# Model: Order
# =========================================================
# Description:
# Represents a customer order in the LOVEN application.
#
# Relationships:
# - Belongs to one user
# - Can contain many order items
#
# Purpose:
# Stores order information inside the database
# and inherits shared audit fields from BaseModel.
#
# Inherited from BaseModel:
# - id
# - created_at
# - updated_at
# - deleted_at
# - soft_delete()
# - restore()
# =========================================================

class Order(BaseModel):
    # Database table name
    __tablename__ = "orders"

    # Reference to the user who placed the order
    user_id = db.Column(
        db.UUID(as_uuid=True),
        db.ForeignKey("users.id"),
        nullable=False
    )

    # Total monetary value of the order
    total_price = db.Column(
        db.Numeric(10, 2),
        nullable=False
    )

    # Current order status
    # Example values:
    # - pending
    # - paid
    # - shipped
    # - delivered
    status = db.Column(
        db.String(50),
        default="pending",
        nullable=False
    )

    def to_dict(self):
        """
        Converts the Order object into a serializable dictionary.

        Returns:
            dict: Order data formatted for API responses.
        """
        return {
            # Convert UUID values to strings for JSON serialization
            "id": str(self.id) if self.id else None,

            # User associated with the order
            "user_id": str(self.user_id) if self.user_id else None,

            # Convert Decimal values into float for API responses
            "total_price": (
                float(self.total_price)
                if self.total_price is not None
                else None
            ),

            # Current order state
            "status": self.status,

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