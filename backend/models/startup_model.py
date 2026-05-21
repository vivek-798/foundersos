from sqlalchemy import Column, Integer, String, Boolean, JSON, ForeignKey, DateTime, func
from sqlalchemy.orm import relationship
from database.connection import Base

class Startup(Base):
    __tablename__ = "startups"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), index=True)
    description = Column(String(2000))
    category = Column(String(100))
    stage = Column(String(100))
    team_size = Column(String(50))
    is_public = Column(Boolean, default=True)
    required_roles = Column(JSON)
    tech_stack = Column(JSON)
    create_room = Column(Boolean, default=True)
    
    owner_id = Column(Integer, ForeignKey("users.id"))
    
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
