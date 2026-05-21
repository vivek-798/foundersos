from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database.connection import get_db
from models.user_model import User
from schemas.user_schema import UserCreate, UserLogin, Token
from auth.password_handler import get_password_hash, verify_password
from auth.jwt_handler import create_access_token
import logging

# Setup basic logging to print exact errors in terminal
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/signup", response_model=Token)
def signup(user: UserCreate, db: Session = Depends(get_db)):
    try:
        # Check if user exists
        db_user = db.query(User).filter(User.email == user.email).first()
        if db_user:
            raise HTTPException(status_code=400, detail="Email already registered")
        
        # Hash password
        hashed_pw = get_password_hash(user.password)
        
        # Create new user
        new_user = User(
            full_name=user.full_name,
            email=user.email,
            hashed_password=hashed_pw
        )
        
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        
        # Create token
        access_token = create_access_token(data={"sub": new_user.email})
        return {"access_token": access_token, "token_type": "bearer"}
        
    except HTTPException:
        raise # Reraise our own known HTTP errors
    except Exception as e:
        logger.error(f"Error during signup: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database/Server Error: {str(e)}")

@router.post("/login", response_model=Token)
def login(user: UserLogin, db: Session = Depends(get_db)):
    try:
        db_user = db.query(User).filter(User.email == user.email).first()
        if not db_user:
            logger.warning(f"Login failed: User with email '{user.email}' not found.")
            raise HTTPException(status_code=400, detail="Invalid credentials")
            
        if not verify_password(user.password, db_user.hashed_password):
            logger.warning(f"Login failed: Password mismatch for user '{user.email}'.")
            raise HTTPException(status_code=400, detail="Invalid credentials")
            
        access_token = create_access_token(data={"sub": db_user.email})
        return {"access_token": access_token, "token_type": "bearer"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error during login: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Database/Server Error: {str(e)}")
