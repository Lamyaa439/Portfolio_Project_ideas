# =========================================================
# Model: OrderItem
# Description:
# Represents a single artwork item inside an order.
#
# Relationships:
# - Belongs to one order
# - References one artwork
#
# Purpose:
# This model acts as a lightweight data container
# between the repository, service, and API layers.
# =========================================================

class OrderItem:
    def __init__(
        self,
        id=None,
        order_id=None,
        artwork_id=None,
        quantity=None,
        price=None,
    ):
        # Unique identifier for the order item
        self.id = id

        # References the parent order
        self.order_id = order_id

        # References the purchased artwork
        self.artwork_id = artwork_id

        # Number of artwork units purchased
        self.quantity = quantity

        # Price of the artwork at purchase time
        self.price = price

    def to_dict(self):
        """
        Convert the OrderItem object into a serializable dictionary.

        Returns:
            dict: Order item data formatted for API responses.
        """
        return {
            "id": str(self.id) if self.id else None,
            "order_id": str(self.order_id) if self.order_id else None,
            "artwork_id": str(self.artwork_id) if self.artwork_id else None,
            "quantity": self.quantity,
            "price": (
                float(self.price)
                if self.price is not None
                else None
            ),
        }