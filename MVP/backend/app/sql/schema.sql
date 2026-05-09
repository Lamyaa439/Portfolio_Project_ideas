-- ====================
-- LOVEN Schema
-- ====================

/* =======================================================================
TABLE: users
Description: Core authentication and account table for LOVEN app.
Relationships: Acts as the base table for artist_profiles, carts, orders,
favorites, reports, feedback, and verification_requests.
=========================================================================*/
CREATE TABLE IF NOT EXISTS "users" (
    "id" UUID PRIMARY KEY,
    "name" VARCHAR(255),
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "password_hash" VARCHAR(255),
    "system_role" VARCHAR(50),
    "fcm_token" VARCHAR(255),
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP DEFAULT now(),
    "updated_at" TIMESTAMP,
    "deleted_at" TIMESTAMP
);

/* =======================================================================
TABLE: artist_profiles
Description: Stores artist-specific profile information.
Relationships: One-to-one relationship with users. One artist profile can
own many artworks.
=========================================================================*/
CREATE TABLE "artist_profiles" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "portfolio_description" TEXT,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* =======================================================================
TABLE: artworks
Description: Stores artwork listings created by artists.
Relationships: Each artwork belongs to one artist profile and can appear in
cart_items, order_items, favorites, and reports.
=========================================================================*/
CREATE TABLE "artworks" (
    "id" UUID PRIMARY KEY,
    "artist_profile_id" UUID NOT NULL REFERENCES artist_profiles(id) ON DELETE CASCADE,
    "title" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "image_url" TEXT,
    "price" NUMERIC(10,2) NOT NULL,
    "quantity" INT DEFAULT 1 CHECK (quantity > 0),
    "shipping_fee" NUMERIC(10,2) DEFAULT 0,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* =======================================================================
TABLE: carts
Description: Stores each user's shopping cart.
Relationships: One-to-one relationship with users. A cart can contain many
cart_items.
=========================================================================*/
CREATE TABLE "carts" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

/* =======================================================================
TABLE: cart_items
Description: Stores artworks added to a user's cart.
Relationships: Belongs to one cart and one artwork.
=========================================================================*/
CREATE TABLE "cart_items" (
    "id" UUID PRIMARY KEY,
    "cart_id" UUID REFERENCES carts(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "quantity" INT NOT NULL CHECK (quantity > 0),
    UNIQUE(cart_id, artwork_id)
);

/* =======================================================================
TABLE: orders
Description: Stores customer orders.
Relationships: Each order belongs to one user and can have many order_items
and one payment.
=========================================================================*/
CREATE TABLE "orders" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "total_price" NUMERIC(10,2),
    "status" VARCHAR(50) DEFAULT 'pending',
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* =======================================================================
TABLE: order_items
Description: Stores individual artworks inside an order.
Relationships: Belongs to one order and one artwork.
=========================================================================*/
CREATE TABLE "order_items" (
    "id" UUID PRIMARY KEY,
    "order_id" UUID REFERENCES orders(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "quantity" INT NOT NULL CHECK (quantity > 0),
    "price" NUMERIC(10,2) NOT NULL
);

/* =======================================================================
TABLE: favorites
Description: Stores artworks favorited by users.
Relationships: Links users and artworks.
=========================================================================*/
CREATE TABLE "favorites" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, artwork_id)
);

/* =======================================================================
TABLE: reports
Description: Stores user reports against artworks.
Relationships: A report can belong to a user and an artwork.
=========================================================================*/
CREATE TABLE "reports" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID REFERENCES users(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "reason" TEXT NOT NULL,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* =======================================================================
TABLE: feedback
Description: Stores feedback messages submitted by users.
Relationships: Feedback can optionally belong to one user.
=========================================================================*/
CREATE TABLE "feedback" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID REFERENCES users(id) ON DELETE CASCADE,
    "message" TEXT NOT NULL,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* =======================================================================
TABLE: verification_requests
Description: Stores artist verification requests.
Relationships: Each verification request belongs to one user.
=========================================================================*/
CREATE TABLE "verification_requests" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "document_url" TEXT,
    "status" VARCHAR(50) DEFAULT 'pending',
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* =======================================================================
TABLE: payments
Description: Stores payment records for orders.
Relationships: Each payment belongs to one order.
=========================================================================*/
CREATE TABLE "payments" (
    "id" UUID PRIMARY KEY,
    "order_id" UUID REFERENCES orders(id) ON DELETE CASCADE,
    "amount" NUMERIC(10,2) NOT NULL,
    "payment_method" VARCHAR(50),
    "status" VARCHAR(50) DEFAULT 'pending',
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
