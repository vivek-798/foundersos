from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from schemas.user_schema import UserResponse

class JoinRequestCreate(BaseModel):
    startup_id: int
    message: Optional[str] = None

class JoinRequestResponse(BaseModel):
    id: int
    startup_id: int
    startup_title: str
    requester_id: int
    requester: UserResponse
    status: str
    message: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
