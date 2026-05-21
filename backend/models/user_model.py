from sqlalchemy import Column, Integer, String, Boolean, JSON
from database.connection import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(255))
    email = Column(String(255), unique=True)
    hashed_password = Column(String(255))

    # Onboarding Fields
    bio = Column(String(1000), nullable=True)
    interests = Column(JSON, nullable=True)
    skills = Column(JSON, nullable=True)
    has_experience = Column(Boolean, default=False)
    project_name = Column(String(255), nullable=True)
    experience_description = Column(String(2000), nullable=True)
    goal = Column(String(255), nullable=True)
    has_onboarded = Column(Boolean, default=False)