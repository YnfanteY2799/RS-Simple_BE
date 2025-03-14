// @generated automatically by Diesel CLI.

diesel::table! {
    document_type (id) {
        id -> Int2,
        #[max_length = 30]
        name -> Varchar,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        #[max_length = 255]
        updated_by -> Nullable<Varchar>,
    }
}

diesel::table! {
    oauth_account (id) {
        id -> Int4,
        #[max_length = 255]
        provider_account_id -> Varchar,
        provider_id -> Int2,
        user_id -> Int4,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        #[max_length = 255]
        updated_by -> Nullable<Varchar>,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    provider_type (id) {
        id -> Int2,
        #[max_length = 255]
        name -> Varchar,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        #[max_length = 255]
        updated_by -> Nullable<Varchar>,
    }
}

diesel::table! {
    session (id) {
        id -> Uuid,
        user_id -> Int4,
        expires_at -> Timestamptz,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    temporal_tokens (id) {
        id -> Uuid,
        user_id -> Int4,
        #[max_length = 80]
        hashed_token -> Varchar,
        expires_at -> Timestamptz,
        token_type -> Int2,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    token_type (id) {
        id -> Int2,
        #[max_length = 100]
        name -> Varchar,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        #[max_length = 255]
        updated_by -> Nullable<Varchar>,
    }
}

diesel::table! {
    user (id) {
        id -> Int4,
        #[max_length = 255]
        first_name -> Varchar,
        #[max_length = 255]
        last_name -> Varchar,
        #[max_length = 255]
        email -> Varchar,
        verified_email -> Bool,
        #[max_length = 255]
        username -> Varchar,
        #[max_length = 255]
        password_salt -> Varchar,
        #[max_length = 255]
        password -> Varchar,
        birth_date -> Date,
        #[max_length = 100]
        phone_number -> Varchar,
        #[max_length = 100]
        document_id -> Varchar,
        document_type_id -> Int2,
        status_id -> Int2,
        user_type_id -> Int2,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        last_login -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        #[max_length = 255]
        updated_by -> Nullable<Varchar>,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    user_status (id) {
        id -> Int2,
        #[max_length = 60]
        name -> Varchar,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        #[max_length = 255]
        updated_by -> Nullable<Varchar>,
    }
}

diesel::table! {
    user_type (id) {
        id -> Int2,
        #[max_length = 60]
        name -> Varchar,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        #[max_length = 255]
        created_by -> Nullable<Varchar>,
        #[max_length = 255]
        updated_by -> Nullable<Varchar>,
    }
}

diesel::joinable!(oauth_account -> provider_type (provider_id));
diesel::joinable!(oauth_account -> user (user_id));
diesel::joinable!(session -> user (user_id));
diesel::joinable!(temporal_tokens -> token_type (token_type));
diesel::joinable!(temporal_tokens -> user (user_id));
diesel::joinable!(user -> document_type (document_type_id));
diesel::joinable!(user -> user_status (status_id));
diesel::joinable!(user -> user_type (user_type_id));

diesel::allow_tables_to_appear_in_same_query!(
    document_type,
    oauth_account,
    provider_type,
    session,
    temporal_tokens,
    token_type,
    user,
    user_status,
    user_type,
);
