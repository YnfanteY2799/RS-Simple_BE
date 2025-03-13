// use crate::db::models::User;
use actix_web::{cookie::Cookie, post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
pub struct LoginRequest {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Serialize)]
pub struct LoginResponse {
    pub user_id: i32,
    pub username: String,
}

#[post("/Login")]
pub async fn login() -> impl Responder {
    print!("Here we are!");

    HttpResponse::Ok().body("Login Method")
}
