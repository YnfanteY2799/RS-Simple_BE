// use crate::db::models::User;
use actix_web::{cookie::Cookie, post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};

use crate::db::Pool;

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
pub async fn login(pool: web::Data<Pool>, login_data: web::Json<LoginResponse>) -> impl Responder {
    print!("Here we are!");

    HttpResponse::Ok().body("Login Method")
}
