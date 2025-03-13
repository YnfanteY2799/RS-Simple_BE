-- Drop tables with foreign keys first
DROP TABLE IF EXISTS "temporal_tokens" CASCADE;
DROP TABLE IF EXISTS "oauth_account" CASCADE;
DROP TABLE IF EXISTS "session" CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;

-- Then drop the type/regulatory tables
DROP TABLE IF EXISTS "token_type" CASCADE;
DROP TABLE IF EXISTS "provider_type" CASCADE;
DROP TABLE IF EXISTS "user_type" CASCADE;
DROP TABLE IF EXISTS "user_status" CASCADE;
DROP TABLE IF EXISTS "document_type" CASCADE;

-- This file should undo anything in `up.sql`
