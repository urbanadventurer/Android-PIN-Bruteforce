import random
import string

def generate_password(length, use_chars=True, use_digits=True):
    characters = ""
    if use_chars:
        characters += string.ascii_letters
    if use_digits:
        characters += string.digits
    
    if not characters:
        return "No character types selected"

    password = ''.join(random.choice(characters) for _ in range(length))
    return password

def main():
    while True:
        print("Password Generator Menu:")
        print("1. Generate Password")
        print("2. Quit")
        
        choice = input("Enter your choice: ")
        
        if choice == "1":
            length = int(input("Enter password length (4-10): "))
            if length < 4 or length > 10:
                print("Password length must be between 4 and 10 characters.")
                continue
            
            use_chars = input("Include characters (y/n)? ").lower() == "y"
            use_digits = input("Include digits (y/n)? ").lower() == "y"
            
            password = generate_password(length, use_chars, use_digits)
            print("Generated Password:", password)
        elif choice == "2":
            print("Exiting Password Generator.")
            break
        else:
            print("Invalid choice. Please enter 1 or 2.")

if __name__ == "__main__":
    main()
