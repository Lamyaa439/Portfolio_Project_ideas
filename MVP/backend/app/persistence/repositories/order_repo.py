import uuid
from sqlalchemy import text
from app.extensions import db

# =========================================================
# Repository: Order Repository
# Description:
# Handles all database operations related to:
# - orders
# - order_items
#
# Responsibilities:
# - Create customer orders
# - Create order items
# - Retrieve user orders
# - Retrieve incoming artist orders
# - Update order status
#
# Architecture Notes:
# - Uses SQLAlchemy session management
# - Uses raw SQL via sqlalchemy.text()
# - Keeps SQL/database logic isolated from services
# =========================================================


def create_order(user_id, total_price, status="pending"):
    """
    Create a new order record.

    Args:
        user_id (UUID): Customer placing the order.
        total_price (float): Total order amount.
        status (str): Initial order status.

    Returns:
        Row: Newly created order row.
    """

    # Generate a unique order ID
    order_id = str(uuid.uuid4())

    # Raw SQL query for inserting a new order
    query = text("""
        INSERT INTO orders (id, user_id, total_price, status)
        VALUES (:id, :user_id, :total_price, :status)
        RETURNING id, user_id, total_price, status, created_at
    """)

    # Execute query with parameter binding
    result = db.session.execute(query, {
        "id": order_id,
        "user_id": user_id,
        "total_price": total_price,
        "status": status,
    })

    # Persist transaction
    db.session.commit()

    # Return inserted order row
    return result.fetchone()


def create_order_item(order_id, artwork_id, quantity, price):
    """
    Create a new order item.

    Args:
        order_id (UUID): Parent order ID.
        artwork_id (UUID): Purchased artwork ID.
        quantity (int): Quantity purchased.
        price (float): Artwork price at purchase time.

    Returns:
        Row: Newly created order item row.
    """

    # Generate unique order item ID
    order_item_id = str(uuid.uuid4())

    # Raw SQL query for inserting order item
    query = text("""
        INSERT INTO order_items (id, order_id, artwork_id, quantity, price)
        VALUES (:id, :order_id, :artwork_id, :quantity, :price)
        RETURNING id, order_id, artwork_id, quantity, price
    """)

    # Execute query
    result = db.session.execute(query, {
        "id": order_item_id,
        "order_id": order_id,
        "artwork_id": artwork_id,
        "quantity": quantity,
        "price": price,
    })

    # Persist transaction
    db.session.commit()

    # Return inserted order item
    return result.fetchone()


def get_orders_by_user(user_id):
    """
    Retrieve all orders created by a user.

    Args:
        user_id (UUID): User ID.

    Returns:
        list: List of user orders ordered by newest first.
    """

    # Raw SQL query for retrieving user orders
    query = text("""
        SELECT id, user_id, total_price, status, created_at
        FROM orders
        WHERE user_id = :user_id
        ORDER BY created_at DESC
    """)

    # Execute query
    result = db.session.execute(query, {
        "user_id": user_id,
    })

    # Return all matching orders
    return result.fetchall()


def get_incoming_orders_by_artist(artist_profile_id):
    """
    Retrieve all incoming orders for an artist.

    Logic:
    - Join orders with order_items
    - Join order_items with artworks
    - Filter artworks belonging to the artist

    Args:
        artist_profile_id (UUID): Artist profile ID.

    Returns:
        list: Incoming artist orders.
    """

    # Raw SQL query for retrieving artist orders
    query = text("""
        SELECT DISTINCT
            o.id,
            o.user_id,
            o.total_price,
            o.status,
            o.created_at
        FROM orders o
        JOIN order_items oi ON o.id = oi.order_id
        JOIN artworks a ON oi.artwork_id = a.id
        WHERE a.artist_profile_id = :artist_profile_id
        ORDER BY o.created_at DESC
    """)

    # Execute query
    result = db.session.execute(query, {
        "artist_profile_id": artist_profile_id,
    })

    # Return matching orders
    return result.fetchall()


def update_order_status(order_id, status):
    """
    Update the status of an existing order.

    Example statuses:
        - pending
        - paid
        - shipped
        - delivered
        - cancelled

    Args:
        order_id (UUID): Order ID.
        status (str): New order status.

    Returns:
        Row: Updated order row.
    """

    # Raw SQL query for updating order status
    query = text("""
        UPDATE orders
        SET status = :status
        WHERE id = :order_id
        RETURNING id, user_id, total_price, status, created_at
    """)

    # Execute query
    result = db.session.execute(query, {
        "order_id": order_id,
        "status": status,
    })

    # Persist transaction
    db.session.commit()

    # Return updated order
    return result.fetchone()