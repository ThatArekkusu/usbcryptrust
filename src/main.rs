use dotenv::dotenv;
use std::env;
use std::fs;

fn main() {
    dotenv().ok();

    let encryption_key = env::var("ENCRYPTION_KEY").expect("Enviornment Variable not found");
    let bitwise_encryption_key - encryption_key.to_bytes;
}
