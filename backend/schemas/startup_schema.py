# Pydantic models for Startup

from pydantic import BaseModel
from typing import List, Optional

from datetime import datetime

class StartupCreate(BaseModel):
    title: str
    description: str
    category: str
    stage: str
    team_size: str
    is_public: bool = True
    required_roles: List[str] = []
    tech_stack: List[str] = []
    create_room: bool = True

class StartupResponse(StartupCreate):
    id: int
    owner_id: int
    owner_name: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        orm_mode = True
