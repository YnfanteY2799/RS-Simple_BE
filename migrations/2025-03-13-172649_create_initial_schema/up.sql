-- Create regulatory/type tables first
CREATE TABLE "document_type" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(30) NOT NULL,
    "create_time" DATE NOT NULL DEFAULT CURRENT_DATE,
    "update_time" DATE
);

CREATE TABLE "user_status" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(60) NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE
);

CREATE TABLE "user_type" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(60) NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE
);

CREATE TABLE "provider_type" (
    "id" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(255) NOT NULL,
    "create_time" DATE NOT NULL DEFAULT CURRENT_DATE,
    "update_time" DATE
);

CREATE TABLE "token_type" (
    "id" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(100) NOT NULL,
    "create_time" DATE NOT NULL DEFAULT CURRENT_DATE,
    "update_time" DATE
);

-- Create main tables with foreign key references
CREATE TABLE "user" (
    "id" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "first_name" VARCHAR(255) NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "verified_email" BOOLEAN NOT NULL DEFAULT FALSE,
    "username" VARCHAR(255) NOT NULL UNIQUE,
    "password_salt" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "birth_date" DATE NOT NULL,
    "phone_number" VARCHAR(100) NOT NULL,
    "document_id" VARCHAR(40) NOT NULL UNIQUE,
    "document_type_id" SMALLINT NOT NULL,
    "status_id" SMALLINT NOT NULL DEFAULT 1,
    "user_type_id" SMALLINT NOT NULL DEFAULT 1,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE DEFAULT NULL,
    FOREIGN KEY ("document_type_id") REFERENCES "document_type" ("id"),
    FOREIGN KEY ("status_id") REFERENCES "user_status" ("id"),
    FOREIGN KEY ("user_type_id") REFERENCES "user_type" ("id")
);

CREATE TABLE "session" (
    "id" VARCHAR(255) PRIMARY KEY DEFAULT gen_random_uuid (),
    "user_id" INTEGER NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY ("user_id") REFERENCES "user" ("id")
);

CREATE TABLE "oauth_account" (
    "id" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "provider_account_id" VARCHAR(255) NOT NULL UNIQUE,
    "provider_id" SMALLINT NOT NULL,
    "user_id" INTEGER NOT NULL,
    FOREIGN KEY ("provider_id") REFERENCES "provider_type" ("id"),
    FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE
);

CREATE TABLE "temporal_tokens" (
    "id" VARCHAR(60) PRIMARY KEY DEFAULT gen_random_uuid (),
    "user_id" INTEGER NOT NULL,
    "hashed_token" VARCHAR(80) NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "token_type" INTEGER NOT NULL,
    "created_time" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("token_type") REFERENCES "token_type" ("id")
);

-- Create indexes for better performance
CREATE INDEX "user_email_idx" ON "user" ("email");

CREATE INDEX "session_user_id_idx" ON "session" ("user_id");

CREATE INDEX "oauth_account_user_id_idx" ON "oauth_account" ("user_id");

CREATE INDEX "temporal_tokens_user_id_idx" ON "temporal_tokens" ("user_id");

CREATE INDEX "temporal_tokens_hashed_token_idx" ON "temporal_tokens" ("hashed_token");

-- Your SQL goes here