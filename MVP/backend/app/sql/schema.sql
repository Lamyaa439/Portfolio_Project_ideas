-- ====================
-- LOVEN Schema 
-- ====================

/* =======================================================================
TABLE: users
Description: The core authentication and account table for LOVEN APP
Relationships: Acts as the base for "artist_profiles" (1-1 relationship)
=========================================================================*/
CREATE TABLE IF NOT EXISTS "users" (
    "id" UUID,
    "name" VARCHAR(255),
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "password_hash" VARCHAR(255), -- Stored as a bcrypt hash
    "system_role" VARCHAR(50), -- Expected values: 'admin', 'customer', 'artist'
    "fcm_token" VARCHAR(255), -- Firebase Cloud Messaging token
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP DEFAULT now(),
    "updated_at" TIMESTAMP,
    "deleted_at" TIMESTAMP,

    PRIMARY KEY("id")
);
CREATE TABLE Artworks (
    id SERIAL PRIMARY KEY,
    artist_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    image_url TEXT,
    price NUMERIC(10,2) NOT NULL,
    quantity INT DEFAULT 1,
    shipping_fee NUMERIC(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Favorites (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    artwork_id INT REFERENCES Artworks(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, artwork_id)
);

CREATE TABLE Cart (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL
);

CREATE TABLE Cart_Items (
    id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES Cart(id) ON DELETE CASCADE,
    artwork_id INT REFERENCES Artworks(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    UNIQUE(cart_id, artwork_id)
);

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    total_price NUMERIC(10,2),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Order_Items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(id) ON DELETE CASCADE,
    artwork_id INT REFERENCES Artworks(id),
    quantity INT NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

CREATE TABLE Shipments (
    id SERIAL PRIMARY KEY,
    order_id INT UNIQUE REFERENCES Orders(id) ON DELETE CASCADE,
    shipping_company VARCHAR(100),
    tracking_number VARCHAR(150),
    status VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Reports (
    id SERIAL PRIMARY KEY,
    user_id INT,
    artwork_id INT REFERENCES Artworks(id) ON DELETE CASCADE,
    reason TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Feedback (
    id SERIAL PRIMARY KEY,
    user_id INT,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
