from app.persistence.repositories.order_repo import (
    create_order,
    create_order_item,
    get_orders_by_user,
    get_incoming_orders_by_artist,
    update_order_status,
)

from app.external_services.notification_service import (
    send_order_shipped_notification,
)


# =========================================================
# Service: Order Service
# Description:
# Contains business logic for order management.
#
# Responsibilities:
# - Create orders
# - Add order items
# - Retrieve user purchase history
# - Retrieve artist incoming orders
# - Update order status
# - Trigger shipment notifications
#
# Note:
# This layer should contain business rules and validation.
# SQL/database logic belongs in the repository layer.
# =========================================================


def create_user_order(data):
    """
    Create a new order and its order items.

    Expected data:
        - user_id
        - total_price
        - items: [
            {
                "artwork_id": "...",
                "quantity": 1,
                "price": 100.00
            }
        ]

    Returns:
        tuple: Response dictionary and HTTP status code.
    """

    user_id = data.get("user_id")
    total_price = data.get("total_price")
    items = data.get("items", [])

    # Validate user ID
    if not user_id:
        return {"error": "user_id is required"}, 400

    # Validate total price
    if total_price is None:
        return {"error": "total_price is required"}, 400

    # Ensure order contains items
    if not items:
        return {"error": "Order must contain at least one item"}, 400

    # Create the parent order
    order = create_order(
        user_id=user_id,
        total_price=total_price,
        status="pending",
    )

    order_id = order[0]
    created_items = []

    # Create each order item
    for item in items:
        artwork_id = item.get("artwork_id")
        quantity = item.get("quantity")
        price = item.get("price")

        # Validate item payload
        if not artwork_id or not quantity or price is None:
            return {
                "error": "Each item must include artwork_id, quantity, and price"
            }, 400

        # Persist order item
        order_item = create_order_item(
            order_id=order_id,
            artwork_id=artwork_id,
            quantity=quantity,
            price=price,
        )

        created_items.append({
            "id": str(order_item[0]),
            "order_id": str(order_item[1]),
            "artwork_id": str(order_item[2]),
            "quantity": order_item[3],
            "price": float(order_item[4]),
        })

    return {
        "message": "Order created successfully",
        "order": {
            "id": str(order[0]),
            "user_id": str(order[1]),
            "total_price": float(order[2]),
            "status": order[3],
            "created_at": order[4].isoformat() if order[4] else None,
            "items": created_items,
        },
    }, 201


def get_user_orders(user_id):
    """
    Retrieve all orders placed by a user.

    Args:
        user_id (UUID): User ID.

    Returns:
        tuple: Response dictionary and HTTP status code.
    """

    if not user_id:
        return {"error": "user_id is required"}, 400

    # Retrieve user orders
    orders = get_orders_by_user(user_id)

    return {
        "orders": [
            {
                "id": str(order[0]),
                "user_id": str(order[1]),
                "total_price": (
                    float(order[2])
                    if order[2] is not None
                    else None
                ),
                "status": order[3],
                "created_at": (
                    order[4].isoformat()
                    if order[4]
                    else None
                ),
            }
            for order in orders
        ]
    }, 200


def get_artist_orders(artist_profile_id):
    """
    Retrieve incoming orders for an artist.

    Args:
        artist_profile_id (UUID): Artist profile ID.

    Returns:
        tuple: Response dictionary and HTTP status code.
    """

    if not artist_profile_id:
        return {"error": "artist_profile_id is required"}, 400

    # Retrieve artist orders
    orders = get_incoming_orders_by_artist(
        artist_profile_id
    )

    return {
        "orders": [
            {
                "id": str(order[0]),
                "user_id": str(order[1]),
                "total_price": (
                    float(order[2])
                    if order[2] is not None
                    else None
                ),
                "status": order[3],
                "created_at": (
                    order[4].isoformat()
                    if order[4]
                    else None
                ),
            }
            for order in orders
        ]
    }, 200


def change_order_status(order_id, status):
    """
    Update the status of an order.

    Args:
        order_id (UUID): Order ID.
        status (str): New order status.

    Returns:
        tuple: Response dictionary and HTTP status code.
    """

    # Validate order ID
    if not order_id:
        return {"error": "order_id is required"}, 400

    # Validate status
    if not status:
        return {"error": "status is required"}, 400

    # Allowed order statuses
    allowed_statuses = [
        "pending",
        "paid",
        "shipped",
        "delivered",
        "cancelled",
    ]

    # Reject invalid statuses
    if status not in allowed_statuses:
        return {"error": "Invalid order status"}, 400

    # Update order status
    order = update_order_status(order_id, status)

    # Ensure order exists
    if not order:
        return {"error": "Order not found"}, 404

    # =====================================================
    # Shipment Notification Integration
    # =====================================================
    # Reuses Firebase Cloud Messaging (FCM)
    # infrastructure to notify buyers when
    # their order has been shipped.
    #
    # NOTE:
    # The buyer FCM token is temporarily mocked.
    # Later this should be retrieved from the
    # users table using the buyer's user_id.
    # =====================================================

    if status == "shipped":

        # TODO:
        # Replace with real buyer FCM token lookup
        buyer_fcm_token = "BUYER_FCM_TOKEN"

        # Dispatch shipment notification
        send_order_shipped_notification(
            fcm_token=buyer_fcm_token,
            order_id=str(order[0]),
        )

    return {
        "message": "Order status updated successfully",
        "order": {
            "id": str(order[0]),
            "user_id": str(order[1]),
            "total_price": (
                float(order[2])
                if order[2] is not None
                else None
            ),
            "status": order[3],
            "created_at": (
                order[4].isoformat()
                if order[4]
                else None
            ),
        },
    }, 200