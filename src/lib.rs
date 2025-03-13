use actix_cors::Cors;
use actix_web::middleware::Logger;
use actix_web::{web, App};

// Module declarations
pub mod controllers;
pub mod db;
pub mod middlewares;
pub mod utils;
// pub mod models;
// pub mod utils;
// pub mod workers;

// App configuration function
pub fn configure_app(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::scope("/api")
            // Auth routes
            .service(web::scope("/auth").service(controllers::auth::login::login))
            .service(controllers::auth::register::register)
            .service(controllers::auth::forgot_password::forgot_password),
        // File routes
        // .service(
        // web::scope("/files")
        // .service(controllers::files::upload)
        // .service(controllers::files::download)
        // .service(controllers::files::delete)
        // .service(controllers::files::get_by_id),
        // ),
    );
}

// Application factory
pub fn create_app() -> App<
    impl actix_web::dev::ServiceFactory<
        actix_web::dev::ServiceRequest,
        Config = (),
        Error = actix_web::Error,
        InitError = (),
    >,
> {
    App::new()
        // Enable logger middleware
        .wrap(Logger::default())
        // Enable CORS middleware
        .wrap(
            Cors::default()
                .allow_any_origin()
                .allow_any_method()
                .allow_any_header(),
        )
        // Enable authentication middleware
        // .wrap(middleware::auth::Authentication)
        // Enable response formatting middleware
        // .wrap(middleware::responses::ResponseFormatter)
        // Configure routes
        .configure(configure_app)
        // Error handlers
        .app_data(
            web::JsonConfig::default()
                .error_handler(|err, _| middlewares::errors::bad_request(err.to_string()).into()),
        )
}
