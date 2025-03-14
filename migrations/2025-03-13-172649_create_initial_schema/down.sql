-- down.sql
-- Drop triggers first
DROP TRIGGER IF EXISTS update_document_type_timestamp ON "document_type";

DROP TRIGGER IF EXISTS update_user_status_timestamp ON "user_status";

DROP TRIGGER IF EXISTS update_user_type_timestamp ON "user_type";

DROP TRIGGER IF EXISTS update_provider_type_timestamp ON "provider_type";

DROP TRIGGER IF EXISTS update_token_type_timestamp ON "token_type";

DROP TRIGGER IF EXISTS update_user_timestamp ON "user";

DROP TRIGGER IF EXISTS update_session_timestamp ON "session";

DROP TRIGGER IF EXISTS update_oauth_account_timestamp ON "oauth_account";

DROP TRIGGER IF EXISTS update_temporal_tokens_timestamp ON "temporal_tokens";

-- Drop the trigger function
DROP FUNCTION IF EXISTS update_timestamp;

-- Drop indexes
DROP INDEX IF EXISTS "user_email_idx";

DROP INDEX IF EXISTS "user_username_idx";

DROP INDEX IF EXISTS "user_document_id_idx";

DROP INDEX IF EXISTS "user_document_type_id_idx";

DROP INDEX IF EXISTS "user_status_id_idx";

DROP INDEX IF EXISTS "user_user_type_id_idx";

DROP INDEX IF EXISTS "user_verified_email_idx";

DROP INDEX IF EXISTS "session_user_id_idx";

DROP INDEX IF EXISTS "session_expires_at_idx";

DROP INDEX IF EXISTS "oauth_account_user_id_idx";

DROP INDEX IF EXISTS "oauth_account_provider_id_idx";

DROP INDEX IF EXISTS "oauth_account_user_provider_idx";

DROP INDEX IF EXISTS "temporal_tokens_user_id_idx";

DROP INDEX IF EXISTS "temporal_tokens_hashed_token_idx";

DROP INDEX IF EXISTS "temporal_tokens_token_type_idx";

DROP INDEX IF EXISTS "temporal_tokens_expires_at_idx";

-- Drop tables in reverse order to respect foreign key dependencies
DROP TABLE IF EXISTS "temporal_tokens";

DROP TABLE IF EXISTS "oauth_account";

DROP TABLE IF EXISTS "session";

DROP TABLE IF EXISTS "user";

DROP TABLE IF EXISTS "token_type";

DROP TABLE IF EXISTS "provider_type";

DROP TABLE IF EXISTS "user_type";

DROP TABLE IF EXISTS "user_status";

DROP TABLE IF EXISTS "document_type";