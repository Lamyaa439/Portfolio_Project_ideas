from flask import Blueprint, request, jsonify
from app.services.facade.order_facade import OrderFacade

# =========================================================
# Blueprint: Orders API
# Description:
# Handles all HTTP endpoints related to:
# - customer orders
# - artist incoming orders
# - order status updates
#
# Responsibilities:
# - Receive client requests
# - Validate/request payload extraction
# - Delegate orchestration/business logic to the Facade layer
# - Return JSON responses
#
# Architectural Change:
# Replaced direct service imports with OrderFacade.
#
# Purpose:
# The Facade acts as an orchestration layer between:
# - API routes
# - order services
# - future integrations such as:
#   - payments
#   - inventory management
#   - Firebase shipment notifications
#
# Note:
# This layer should remain thin and should NOT contain:
# - SQL logic
# - business rules
# - orchestration logic
# =========================================================

# Blueprint for order-related routes
order_bp = Blueprint("orders", __name__)


@order_bp.post("/")
def create_order():
    """
    Create a new order.

    Expected JSON body:
        {
            "user_id": "...",
            "total_price": 100.00,
            "items": [
                {
                    "artwork_id": "...",
                    "quantity": 1,
                    "price": 100.00
                }
            ]
        }

    Returns:
        JSON response containing:
        - created order
        - created order items
    """

    # Extract request payload
    data = request.get_json()

    # Delegate orchestration to the Facade
    result, status_code = OrderFacade.create_order(data)

    return jsonify(result), status_code


@order_bp.get("/user/<user_id>")
def view_user_orders(user_id):
    """
    Retrieve all orders placed by a user.

    Route Params:
        - user_id

    Returns:
        JSON list of user orders.
    """

    # Delegate orchestration to the Facade
    result, status_code = OrderFacade.get_customer_orders(user_id)

    return jsonify(result), status_code


@order_bp.get("/artist/<artist_profile_id>")
def view_artist_orders(artist_profile_id):
    """
    Retrieve incoming orders for an artist.

    Route Params:
        - artist_profile_id

    Returns:
        JSON list of incoming artist orders.
    """

    # Delegate orchestration to the Facade
    result, status_code = OrderFacade.get_artist_incoming_orders(
        artist_profile_id
    )

    return jsonify(result), status_code


@order_bp.patch("/<order_id>/status")
def update_status(order_id):
    """
    Update the status of an existing order.

    Route Params:
        - order_id

    Expected JSON body:
        {
            "status": "shipped"
        }

    Example statuses:
        - pending
        - paid
        - shipped
        - delivered
        - cancelled

    Returns:
        JSON response containing updated order information.
    """

    # Extract request payload
    data = request.get_json()

    # Extract new order status
    status = data.get("status")

    # Delegate orchestration to the Facade
    result, status_code = OrderFacade.update_status(order_id, status)

    return jsonify(result), status_code