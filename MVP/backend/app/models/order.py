# =========================================================
# Model: Order
# Description:
# Represents a customer order in the LOVEN application.
#
# Relationships:
# - Belongs to one user
# - Can contain many order_items
#
# Purpose:
# This model is used as a lightweight data container
# between the repository, service, and API layers.
# =========================================================

class Order:
    def __init__(
        self,
        id=None,
        user_id=None,
        total_price=None,
        status="pending",
        created_at=None,
    ):
        # Unique identifier for the order
        self.id = id

        # References the user who placed the order
        self.user_id = user_id

        # Total cost of the order
        self.total_price = total_price

        # Current order status
        # Example values:
        # - pending
        # - paid
        # - shipped
        # - delivered
        self.status = status

        # Timestamp when the order was created
        self.created_at = created_at

    def to_dict(self):
        """
        Convert the Order object into a serializable dictionary.

        Returns:
            dict: Order data formatted for API responses.
        """
        return {
            "id": str(self.id) if self.id else None,
            "user_id": str(self.user_id) if self.user_id else None,
            "total_price": (
                float(self.total_price)
                if self.total_price is not None
                else None
            ),
            "status": self.status,
            "created_at": (
                self.created_at.isoformat()
                if self.created_at
                else None
            ),
        }