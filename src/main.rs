// main.rs
use actix_web::{middleware::Logger, HttpServer};
use dms_backend::create_app;
use dotenv::dotenv;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Load environment variables
    dotenv().ok();

    // Initialize logger
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    // Get configuration from environment
    let host = std::env::var("HOST").unwrap_or_else(|_| "127.0.0.1".to_string());
    let port = std::env::var("PORT")
        .unwrap_or_else(|_| "8080".to_string())
        .parse::<u16>()
        .expect("PORT must be a number");

    log::info!("Starting server at http://{}:{}", host, port);

    // Start HTTP server
    HttpServer::new(|| create_app())
        .bind((host, port))?
        .run()
        .await
}
