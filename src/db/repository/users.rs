use diesel::prelude::*;
use crate::db::models::users::User;
use crate::db::schema::user::dsl::*;

pub fn find_user_by_username(conn: &mut PgConnection, username_param: &str) -> QueryResult<User> {
    user.filter(username.eq(username_param)).first(conn)
}

// Create a logo for a Tech related company focused on the modern and constant technological improvements, the logo must contain a White Wolf or be White Wolf related, due to the company creed