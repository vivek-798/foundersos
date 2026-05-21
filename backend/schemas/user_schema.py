from pydantic import BaseModel
from typing import List, Optional

class UserCreate(BaseModel):
    full_name: str
    email: str
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class UserOnboarding(BaseModel):
    bio: Optional[str] = None
    interests: List[str] = []
    skills: List[str] = []
    has_experience: bool = False
    project_name: Optional[str] = None
    experience_description: Optional[str] = None
    goal: Optional[str] = None

class UserResponse(BaseModel):
    id: int
    full_name: str
    email: str
    bio: Optional[str] = None
    interests: Optional[List[str]] = []
    skills: Optional[List[str]] = []
    has_experience: bool = False
    project_name: Optional[str] = None
    experience_description: Optional[str] = None
    goal: Optional[str] = None
    has_onboarded: bool

    class Config:
        orm_mode = True
