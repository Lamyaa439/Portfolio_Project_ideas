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
/* ================================
TABLE: artist_profiles
=============================== */
CREATE TABLE "artist_profiles" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID UNIQUE NOT NULL REFERENCES users(id),
    "portfolio_description" TEXT
);

/* ================================
TABLE: artworks
=============================== */
CREATE TABLE "artworks" (
    "id" UUID PRIMARY KEY,
    "artist_profile_id" UUID NOT NULL REFERENCES artist_profiles(id),
    "title" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "image_url" TEXT,
    "price" NUMERIC(10,2) NOT NULL,
    "quantity" INT DEFAULT 1 CHECK (quantity > 0),
    "shipping_fee" NUMERIC(10,2) DEFAULT 0
);

/* ================================
TABLE: carts
=============================== */
CREATE TABLE "carts" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID UNIQUE NOT NULL REFERENCES users(id)
);

/* ================================
TABLE: cart_items
=============================== */
CREATE TABLE "cart_items" (
    "id" UUID PRIMARY KEY,
    "cart_id" UUID REFERENCES carts(id),
    "artwork_id" UUID REFERENCES artworks(id),
    "quantity" INT NOT NULL CHECK (quantity > 0),
    UNIQUE(cart_id, artwork_id)
);

/* ================================
TABLE: orders
=============================== */
CREATE TABLE "orders" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL REFERENCES users(id),
    "total_price" NUMERIC(10,2),
    "status" VARCHAR(50) DEFAULT 'pending'
);

/* ================================
TABLE: order_items
=============================== */
CREATE TABLE "order_items" (
    "id" UUID PRIMARY KEY,
    "order_id" UUID REFERENCES orders(id),
    "artwork_id" UUID REFERENCES artworks(id),
    "quantity" INT NOT NULL CHECK (quantity > 0),
    "price" NUMERIC(10,2) NOT NULL
);

/* ================================
TABLE: favorites
=============================== */
CREATE TABLE "favorites" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL REFERENCES users(id),
    "artwork_id" UUID REFERENCES artworks(id),
    UNIQUE(user_id, artwork_id)
);

/* ================================
TABLE: reports
=============================== */
CREATE TABLE "reports" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID REFERENCES users(id),
    "artwork_id" UUID REFERENCES artworks(id),
    "reason" TEXT NOT NULL
);

/* ================================
TABLE: feedback
=============================== */
CREATE TABLE "feedback" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID REFERENCES users(id),
    "message" TEXT NOT NULL
);

/* ================================
TABLE: verification_requests
=============================== */
CREATE TABLE "verification_requests" (
    "id" UUID PRIMARY KEY,
    "user_id" UUID NOT NULL REFERENCES users(id),
    "document_url" TEXT,
    "status" VARCHAR(50) DEFAULT 'pending'
);

/* ================================
TABLE: payments
=============================== */
CREATE TABLE "payments" (
    "id" UUID PRIMARY KEY,
    "order_id" UUID REFERENCES orders(id),
    "amount" NUMERIC(10,2) NOT NULL,
    "payment_method" VARCHAR(50),
    "status" VARCHAR(50) DEFAULT 'pending'
);
