use dotenv::dotenv;
use std::env;

fn main() {
    dotenv().ok();

    let encryption_key = env::var("ENCRYPTION_KEY").expect("Enviornment variable not found");
    let luks_passphrase = env::var("LUKS_PASSPHRASE").expect("Enviornment Variable not found");

    println!("Encryption key: {} LUKS passphrase: {}", encryption_key, luks_passphrase); //Enviornment Variable loading test

    
}
