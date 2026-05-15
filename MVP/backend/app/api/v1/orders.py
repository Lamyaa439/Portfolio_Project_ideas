from flask import Blueprint, request, jsonify
from app.services.facade.order_facade import OrderFacade

# =========================================================
# Blueprint: Orders API
# Description:
# Handles all HTTP endpoints related to:
# - customer orders
# - artist incoming orders
# - order shipment updates
# - order status management
#
# Responsibilities:
# - Receive HTTP requests
# - Extract request payloads
# - Delegate orchestration to the Facade layer
# - Return JSON responses
#
# Architecture:
# Routes -> Facade -> Service -> Repository
#
# Purpose of Facade:
# The facade layer coordinates:
# - order creation
# - artist order retrieval
# - shipment updates
# - Firebase shipment notifications
# - future integrations (payments, inventory, etc.)
# =========================================================

# Blueprint registration for order-related routes
order_bp = Blueprint("orders", __name__)


# =========================================================
# Route: Create Order
# Method: POST
# Endpoint: /api/v1/orders/
#
# Description:
# Creates a new order and associated order_items.
#
# Expected JSON:
# {
#     "buyer_id": "...",
#     "subtotal": 150.00,
#     "shipping_fee": 20.00,
#     "total_amount": 170.00,
#     "items": [
#         {
#             "artwork_id": "...",
#             "quantity": 1,
#             "price_at_purchase": 150.00
#         }
#     ]
# }
#
# Notes:
# - buyer_id references users.id
# - price_at_purchase preserves historical pricing
# - totals align with LOVEN financial schema
# =========================================================
@order_bp.post("/")
def create_order():

    # Extract JSON payload safely
    data = request.get_json() or {}

    # Delegate orchestration to facade layer
    result, status_code = OrderFacade.create_order(data)

    # Return JSON response
    return jsonify(result), status_code


# =========================================================
# Route: View Buyer Orders
# Method: GET
# Endpoint: /api/v1/orders/buyer/<buyer_id>
#
# Description:
# Retrieves all orders placed by a buyer.
#
# Route Params:
# - buyer_id -> users.id
# =========================================================
@order_bp.get("/buyer/<buyer_id>")
def view_buyer_orders(buyer_id):

    # Delegate retrieval to facade layer
    result, status_code = OrderFacade.get_customer_orders(buyer_id)

    return jsonify(result), status_code


# =========================================================
# Route: View Artist Incoming Orders
# Method: GET
# Endpoint: /api/v1/orders/artist/<artist_profile_id>
#
# Description:
# Retrieves all incoming orders containing artworks
# owned by a specific artist.
#
# Route Params:
# - artist_profile_id -> artist_profiles.id
# =========================================================
@order_bp.get("/artist/<artist_profile_id>")
def view_artist_orders(artist_profile_id):

    # Delegate retrieval to facade layer
    result, status_code = OrderFacade.get_artist_incoming_orders(
        artist_profile_id
    )

    return jsonify(result), status_code


# =========================================================
# Route: Update Order Status
# Method: PATCH
# Endpoint: /api/v1/orders/<order_id>/status
#
# Description:
# Updates order shipment and status information.
#
# Expected JSON:
# {
#     "status": "shipped",
#     "shipping_company": "DHL",
#     "tracking_number": "123456789"
# }
#
# Supported Statuses:
# - pending
# - paid
# - shipped
# - delivered
# - cancelled
#
# Future Integration:
# - Firebase FCM shipment notifications
# - Customer delivery updates
# =========================================================
@order_bp.patch("/<order_id>/status")
def update_status(order_id):

    # Extract JSON payload safely
    data = request.get_json() or {}

    # Extract individual fields
    status = data.get("status")
    shipping_company = data.get("shipping_company")
    tracking_number = data.get("tracking_number")

    # Delegate orchestration to facade layer
    result, status_code = OrderFacade.update_status(
        order_id,
        status,
        shipping_company=shipping_company,
        tracking_number=tracking_number,
    )

    return jsonify(result), status_code