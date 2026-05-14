from app.services.order_service import (
    create_user_order,
    get_user_orders,
    get_artist_orders,
    change_order_status,
)


# =========================================================
# Facade: OrderFacade
# Description:
# Provides a clean orchestration layer for order management.
#
# Purpose:
# The API layer should call this Facade instead of directly
# calling the order service.
#
# Responsibilities:
# - Keep API routes thin
# - Delegate order business logic to order_service
# - Prepare space for future orchestration such as:
#   - payment handling
#   - inventory updates
#   - shipment notifications
#   - buyer notifications through FCM
# =========================================================


class OrderFacade:
    @staticmethod
    def create_order(data):
        """
        Create a customer order.

        Args:
            data (dict): Order request payload.

        Returns:
            tuple: Response dictionary and HTTP status code.
        """
        return create_user_order(data)

    @staticmethod
    def get_customer_orders(user_id):
        """
        Retrieve all orders placed by a customer.

        Args:
            user_id (UUID): Customer user ID.

        Returns:
            tuple: Response dictionary and HTTP status code.
        """
        return get_user_orders(user_id)

    @staticmethod
    def get_artist_incoming_orders(artist_profile_id):
        """
        Retrieve incoming orders for an artist.

        Args:
            artist_profile_id (UUID): Artist profile ID.

        Returns:
            tuple: Response dictionary and HTTP status code.
        """
        return get_artist_orders(artist_profile_id)

    @staticmethod
    def update_status(order_id, status):
        """
        Update an order status.

        Args:
            order_id (UUID): Order ID.
            status (str): New order status.

        Returns:
            tuple: Response dictionary and HTTP status code.
        """
        return change_order_status(order_id, status)