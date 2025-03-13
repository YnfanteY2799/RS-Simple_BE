use actix_web::{post, HttpResponse, Responder};

#[post("/Register")]
pub async fn register() -> impl Responder {
    HttpResponse::Ok().body("body")
}
