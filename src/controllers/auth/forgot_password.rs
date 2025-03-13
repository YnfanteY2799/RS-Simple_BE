use actix_web::{post, HttpResponse, Responder};

#[post("/ForgotPassword")]
pub async fn forgot_password() -> impl Responder {
    HttpResponse::Ok().body("This is the forgot")
}
