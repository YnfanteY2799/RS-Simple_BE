#[derive(Debug, Deserialize)]
pub struct LoginRequestDTO {
    pub password: String,
    pub email: String,
}

#[derive(Debug, Deserialize)]
pub struct LoginResponseDTO {

     
}