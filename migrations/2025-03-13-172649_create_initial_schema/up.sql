-- Create regulatory/type tables first
CREATE TABLE "document_type" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(30) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" VARCHAR(255),
    "updated_by" VARCHAR(255)
);
COMMENT ON TABLE "document_type" IS 'Stores types of identification documents (e.g., passport, driver''s license)';

CREATE TABLE "user_status" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(60) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT NULL,
    "created_by" VARCHAR(255),
    "updated_by" VARCHAR(255),
    CONSTRAINT "user_status_update_check" CHECK (updated_at IS NULL OR updated_at > created_at)
);
COMMENT ON TABLE "user_status" IS 'Stores user status values (e.g., active, inactive, suspended)';

CREATE TABLE "user_type" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(60) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT NULL,
    "created_by" VARCHAR(255),
    "updated_by" VARCHAR(255),
    CONSTRAINT "user_type_update_check" CHECK (updated_at IS NULL OR updated_at > created_at)
);
COMMENT ON TABLE "user_type" IS 'Stores user type categories (e.g., regular, admin, moderator)';

CREATE TABLE "provider_type" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT NULL,
    "created_by" VARCHAR(255),
    "updated_by" VARCHAR(255),
    CONSTRAINT "provider_type_update_check" CHECK (updated_at IS NULL OR updated_at > created_at)
);
COMMENT ON TABLE "provider_type" IS 'Stores OAuth provider types (e.g., Google, Facebook, GitHub)';

CREATE TABLE "token_type" (
    "id" SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT NULL,
    "created_by" VARCHAR(255),
    "updated_by" VARCHAR(255),
    CONSTRAINT "token_type_update_check" CHECK (updated_at IS NULL OR updated_at > created_at)
);
COMMENT ON TABLE "token_type" IS 'Stores types of temporary tokens (e.g., password_reset, email_verification)';

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
    "document_id" VARCHAR(100) NOT NULL UNIQUE,
    "document_type_id" SMALLINT NOT NULL,
    "status_id" SMALLINT NOT NULL DEFAULT 1,
    "user_type_id" SMALLINT NOT NULL DEFAULT 1,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT NULL,
    "last_login" TIMESTAMPTZ DEFAULT NULL,
    "created_by" VARCHAR(255),
    "updated_by" VARCHAR(255),
    "deleted_at" TIMESTAMPTZ DEFAULT NULL,
    FOREIGN KEY ("document_type_id") REFERENCES "document_type" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("status_id") REFERENCES "user_status" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("user_type_id") REFERENCES "user_type" ("id") ON DELETE CASCADE,
    CONSTRAINT "user_update_check" CHECK (updated_at IS NULL OR updated_at > created_at)
);

CREATE TABLE "session" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" INTEGER NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT NULL,
    "created_by" VARCHAR(255),
    "deleted_at" TIMESTAMPTZ DEFAULT NULL,
    FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE,
    CONSTRAINT "session_expires_future_check" CHECK (expires_at > created_at)
);

CREATE TABLE "oauth_account" (
    "id" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "provider_account_id" VARCHAR(255) NOT NULL,
    "provider_id" SMALLINT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ,
    "created_by" VARCHAR(255),
    "updated_by" VARCHAR(255),
    "deleted_at" TIMESTAMPTZ DEFAULT NULL,
    FOREIGN KEY ("provider_id") REFERENCES "provider_type" ("id") ON DELETE RESTRICT,
    FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE,
    UNIQUE ("provider_account_id", "provider_id"),
    CONSTRAINT "oauth_account_update_check" CHECK (updated_at IS NULL OR updated_at > created_at)
);

CREATE TABLE "temporal_tokens" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" INTEGER NOT NULL,
    "hashed_token" VARCHAR(80) NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "token_type" SMALLINT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT NULL,
    "created_by" VARCHAR(255),
    "deleted_at" TIMESTAMPTZ DEFAULT NULL,
    FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("token_type") REFERENCES "token_type" ("id") ON DELETE CASCADE,
    CONSTRAINT "token_expires_future_check" CHECK (expires_at > created_at)
);

-- Create indexes for better performance
CREATE INDEX "user_email_idx" ON "user" ("email");
CREATE INDEX "user_username_idx" ON "user" ("username");
CREATE INDEX "user_document_id_idx" ON "user" ("document_id");
CREATE INDEX "user_document_type_id_idx" ON "user" ("document_type_id");
CREATE INDEX "user_status_id_idx" ON "user" ("status_id");
CREATE INDEX "user_user_type_id_idx" ON "user" ("user_type_id");
CREATE INDEX "user_verified_email_idx" ON "user" ("verified_email") WHERE verified_email = TRUE;

CREATE INDEX "session_user_id_idx" ON "session" ("user_id");
CREATE INDEX "session_expires_at_idx" ON "session" ("expires_at");

CREATE INDEX "oauth_account_user_id_idx" ON "oauth_account" ("user_id");
CREATE INDEX "oauth_account_provider_id_idx" ON "oauth_account" ("provider_id");
CREATE INDEX "oauth_account_user_provider_idx" ON "oauth_account" ("user_id", "provider_id");

CREATE INDEX "temporal_tokens_user_id_idx" ON "temporal_tokens" ("user_id");
CREATE INDEX "temporal_tokens_hashed_token_idx" ON "temporal_tokens" ("hashed_token");
CREATE INDEX "temporal_tokens_token_type_idx" ON "temporal_tokens" ("token_type");
CREATE INDEX "temporal_tokens_expires_at_idx" ON "temporal_tokens" ("expires_at");

-- Comments for clarity
COMMENT ON COLUMN "user"."phone_number" IS 'Recommended format: international format with optional +, digits, spaces, hyphens, and parentheses';
COMMENT ON COLUMN "user"."password" IS 'Stores hashed password, not plaintext';
COMMENT ON TABLE "user" IS 'Stores user authentication and profile information';
COMMENT ON TABLE "session" IS 'Tracks active user sessions';
COMMENT ON TABLE "oauth_account" IS 'Links users to their OAuth provider accounts';
COMMENT ON TABLE "temporal_tokens" IS 'Stores temporary tokens for password reset, email verification, etc.';

-- Create triggers to automatically update the updated_at timestamps
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers to all tables with updated_at column
CREATE TRIGGER update_document_type_timestamp BEFORE UPDATE ON "document_type" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_user_status_timestamp BEFORE UPDATE ON "user_status" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_user_type_timestamp BEFORE UPDATE ON "user_type" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_provider_type_timestamp BEFORE UPDATE ON "provider_type" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_token_type_timestamp BEFORE UPDATE ON "token_type" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_user_timestamp BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_session_timestamp BEFORE UPDATE ON "session" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_oauth_account_timestamp BEFORE UPDATE ON "oauth_account" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
CREATE TRIGGER update_temporal_tokens_timestamp BEFORE UPDATE ON "temporal_tokens" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

-- Example inserts for reference tables
INSERT INTO "document_type" ("name", "created_by") VALUES ('Passport', 'system'), ('Driver''s License', 'system');
INSERT INTO "user_status" ("name", "created_by") VALUES ('Active', 'system'), ('Inactive', 'system'), ('Suspended', 'system');
INSERT INTO "user_type" ("name", "created_by") VALUES ('Regular', 'system'), ('Admin', 'system'), ('Moderator', 'system');
INSERT INTO "provider_type" ("name", "created_by") VALUES ('Google', 'system'), ('Facebook', 'system'), ('GitHub', 'system');
INSERT INTO "token_type" ("name", "created_by") VALUES ('Password Reset', 'system'), ('Email Verification', 'system');