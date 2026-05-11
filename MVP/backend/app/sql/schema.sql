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
    "password" VARCHAR(255), -- Stored as a bcrypt hash
    "system_role" VARCHAR(50), -- Expected values: 'admin', 'customer', 'artist'
    "fcm_token" VARCHAR(255), -- Firebase Cloud Messaging token
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP DEFAULT now(),
    "updated_at" TIMESTAMP,
    "deleted_at" TIMESTAMP,

    PRIMARY KEY("id")
);
