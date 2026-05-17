"""
Cart facade.

Thin orchestrator for shopping cart API flows. Delegates all business logic
to cart_service. No external integrations at this layer.
"""

from app.services import cart_service


class CartFacade:
    """
    Entry point for cart routes.

    Every method returns:
        tuple: (response dict, HTTP status code)
    """

    @staticmethod
    def get(user_id, include_artwork=True):
        """
        Return the authenticated user's cart and line items.

        Args:
            user_id: Authenticated user ID (from JWT).
            include_artwork: Embed artwork snapshot on each line item.

        Returns:
            200 with cart payload; 404 if user not found.
        """
        return cart_service.get_cart(user_id, include_artwork=include_artwork)

    @staticmethod
    def add(user_id, data: dict):
        """
        Add an artwork to the cart or increase quantity if already present.

        Args:
            user_id: Authenticated user ID (from JWT).
            data: JSON body with artwork_id (required) and quantity (optional).

        Returns:
            201 when a new line is created; 200 when quantity is increased.
        """
        return cart_service.add_to_cart(user_id, data)

    @staticmethod
    def update_item(user_id, item_id, data: dict):
        """
        Replace the quantity on a cart line.

        Args:
            user_id: Authenticated user ID (from JWT).
            item_id: CartItem primary key.
            data: JSON body with quantity (required).

        Returns:
            200 on success; 400/403/404/500 on failure.
        """
        return cart_service.update_cart_item(user_id, item_id, data)

    @staticmethod
    def remove_item(user_id, item_id):
        """
        Remove one line from the user's cart.

        Args:
            user_id: Authenticated user ID (from JWT).
            item_id: CartItem primary key.

        Returns:
            200 on success; 403/404/500 on failure.
        """
        return cart_service.remove_cart_item(user_id, item_id)

    @staticmethod
    def clear(user_id):
        """
        Remove all items from the user's cart.

        Args:
            user_id: Authenticated user ID (from JWT).

        Returns:
            200 with cleared count.
        """
        return cart_service.clear_cart(user_id)
