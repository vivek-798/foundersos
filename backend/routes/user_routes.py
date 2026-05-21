from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from jose import jwt, JWTError
from database.connection import get_db
from models.user_model import User
from schemas.user_schema import UserOnboarding, UserResponse
from auth.jwt_handler import SECRET_KEY, ALGORITHM

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    user = db.query(User).filter(User.email == email).first()
    if user is None:
        raise credentials_exception
    return user

@router.get("/me", response_model=UserResponse)
def get_user_profile(current_user: User = Depends(get_current_user)):
    return current_user

@router.get("/{user_id}", response_model=UserResponse)
def get_user_by_id(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.put("/onboarding")
def update_onboarding(onboarding_data: UserOnboarding, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    try:
        current_user.bio = onboarding_data.bio
        current_user.interests = onboarding_data.interests
        current_user.skills = onboarding_data.skills
        current_user.has_experience = onboarding_data.has_experience
        current_user.project_name = onboarding_data.project_name
        current_user.experience_description = onboarding_data.experience_description
        current_user.goal = onboarding_data.goal
        current_user.has_onboarded = True
        
        db.commit()
        db.refresh(current_user)
        return {"message": "Onboarding completed successfully", "user": current_user}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
