use chrono::NaiveDate;
use diesel::prelude::*;
use serde::{Deserialize, Serialize};

use crate::db::schema::schema::document_type;
use crate::db::schema::schema::user;
use crate::db::schema::schema::user_status;
use crate::db::schema::schema::user_type;

#[derive(Debug, Serialize, Deserialize, Queryable, Identifiable, PartialEq)]
#[diesel(table_name = crate::db::schema::schema::user)]
#[diesel(check_for_backend(diesel::pg::Pg))]
#[diesel(primary_key(id))]
pub struct User {
    pub id: i32,
    pub first_name: String,
    pub last_name: String,
    pub email: String,
    pub verified_email: bool,
    pub username: String,
    pub password_salt: String,
    pub password: String,
    pub birth_date: NaiveDate,
    pub phone_number: String,
    pub document_id: String,
    pub document_type_id: i16,
    pub status_id: i16,
    pub user_type_id: i16,
    pub created_at: NaiveDate,
    pub updated_at: Option<NaiveDate>,
}

#[derive(Debug, Deserialize, Serialize, Insertable)]
#[diesel(table_name = user)]
pub struct NewUser {
    pub first_name: String,
    pub last_name: String,
    pub email: String,
    pub verified_email: bool,
    pub username: String,
    pub password_salt: String,
    pub password: String,
    pub birth_date: NaiveDate,
    pub phone_number: String,
    pub document_id: String,
    pub document_type_id: i16,
    pub status_id: i16,
    pub user_type_id: i16,
}

#[derive(Debug, Deserialize, Serialize, AsChangeset)]
#[diesel(table_name = user)]
pub struct UpdateUser {
    pub first_name: Option<String>,
    pub last_name: Option<String>,
    pub email: Option<String>,
    pub verified_email: Option<bool>,
    pub username: Option<String>,
    pub password_salt: Option<String>,
    pub password: Option<String>,
    pub birth_date: Option<NaiveDate>,
    pub phone_number: Option<String>,
    pub document_id: Option<String>,
    pub document_type_id: Option<i16>,
    pub status_id: Option<i16>,
    pub user_type_id: Option<i16>,
}
