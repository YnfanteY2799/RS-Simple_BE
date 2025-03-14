use crate::db::{models::users::User, schema::schema::user::username};
use diesel::prelude::*;

pub fn find_user_by_username(conn: &mut PgConnection, username_param: &str) {}

// Create a logo for a Tech related company focused on the modern and constant technological improvements, the logo must contain a White Wolf or be White Wolf related, due to the company creed
