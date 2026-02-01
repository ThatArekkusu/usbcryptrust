TEMPORARY README AS A BASIC DESCRIPTION

private USB key generator and handler for decrypting an Arch Linux system which has been encrypted with LUKS

Goals:
- Have a shell script to create the required directorys and set up the USB key which encrypting it with LUKS, generating a secure password, generating PGP keys to transfer the systems encryption password securely etc..
- Create a system service with systemd to make the neccasary information exchange happen before the system requests the password
- Either have it print the password for you to enter when booting OR automatically input it such that the USB becomess a requirement to boot into the system

This project is very in the works, not very far into development and im still unsure about alot of the means and things that will be nessasary for this project, it is worth noting this project will NOT be vibe coded and AI will be kept to a minimum and only used for explanations or simple purpouses