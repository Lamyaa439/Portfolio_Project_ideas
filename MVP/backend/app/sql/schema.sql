-- ====================
-- LOVEN Schema 
-- ====================

/* =======================================================================
TABLE: users
Description: The core authentication and account table for LOVEN APP
Relationships: Acts as the base for "artist_profiles" (1-1 relationship)
=========================================================================*/
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS "users" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(255),
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "password_hash" VARCHAR(255), -- Stored as a bcrypt hash
    "system_role" VARCHAR(50), -- Expected values: 'admin', 'customer', 'artist'
    "fcm_token" VARCHAR(255), -- Firebase Cloud Messaging token
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP DEFAULT now(),
    "updated_at" TIMESTAMP,
    "deleted_at" TIMESTAMP,
);

CREATE TABLE "artist_profiles" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "portfolio_description" TEXT,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "artworks" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "artist_profile_id" UUID NOT NULL REFERENCES artist_profiles(id) ON DELETE CASCADE,
    "title" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "image_url" TEXT,
    "price" NUMERIC(10,2) NOT NULL,
    "quantity" INT DEFAULT 1 CHECK (quantity > 0),
    "shipping_fee" NUMERIC(10,2) DEFAULT 0,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "carts" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE "cart_items" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "cart_id" UUID REFERENCES carts(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "quantity" INT NOT NULL CHECK (quantity > 0),
    UNIQUE(cart_id, artwork_id)
);

CREATE TABLE "orders" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "total_price" NUMERIC(10,2),
    "status" VARCHAR(50) DEFAULT 'pending',
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "order_items" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "order_id" UUID REFERENCES orders(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "quantity" INT NOT NULL CHECK (quantity > 0),
    "price" NUMERIC(10,2) NOT NULL
);

CREATE TABLE "favorites" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, artwork_id)
);

CREATE TABLE "reports" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID REFERENCES users(id) ON DELETE CASCADE,
    "artwork_id" UUID REFERENCES artworks(id) ON DELETE CASCADE,
    "reason" TEXT NOT NULL,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "feedback" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID REFERENCES users(id) ON DELETE CASCADE,
    "message" TEXT NOT NULL,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "verification_requests" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    "document_url" TEXT,
    "status" VARCHAR(50) DEFAULT 'pending',
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "payments" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "order_id" UUID REFERENCES orders(id) ON DELETE CASCADE,
    "amount" NUMERIC(10,2) NOT NULL,
    "payment_method" VARCHAR(50),
    "status" VARCHAR(50) DEFAULT 'pending',
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
