import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from database.connection import SessionLocal
from models.user_model import User
from auth.password_handler import get_password_hash

def seed_users():
    db = SessionLocal()
    try:
        user1_email = "alice@foundersos.com"
        user2_email = "bob@foundersos.com"
        
        # Insert user 1 if not exists
        if not db.query(User).filter(User.email == user1_email).first():
            user1 = User(
                full_name="Alice Founder",
                email=user1_email,
                hashed_password=get_password_hash("password123")
            )
            db.add(user1)
            
        # Insert user 2 if not exists
        if not db.query(User).filter(User.email == user2_email).first():
            user2 = User(
                full_name="Bob Builder",
                email=user2_email,
                hashed_password=get_password_hash("password123")
            )
            db.add(user2)
            
        db.commit()
        print("Successfully inserted 2 dummy users.")
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_users()
