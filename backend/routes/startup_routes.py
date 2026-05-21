from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from database.connection import get_db
from routes.user_routes import get_current_user
from models.user_model import User
from models.startup_model import Startup
from models.join_request_model import JoinRequest
from schemas.startup_schema import StartupCreate, StartupResponse
from schemas.join_request_schema import JoinRequestCreate, JoinRequestResponse

router = APIRouter()

@router.post("/", response_model=StartupResponse)
def create_startup(startup: StartupCreate, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    new_startup = Startup(
        title=startup.title,
        description=startup.description,
        category=startup.category,
        stage=startup.stage,
        team_size=startup.team_size,
        is_public=startup.is_public,
        required_roles=startup.required_roles,
        tech_stack=startup.tech_stack,
        create_room=startup.create_room,
        owner_id=current_user.id
    )
    db.add(new_startup)
    db.commit()
    db.refresh(new_startup)
    
    # Set owner name dynamically for the response schema
    new_startup.owner_name = current_user.full_name
    return new_startup

@router.get("/", response_model=List[StartupResponse])
def get_startups(db: Session = Depends(get_db)):
    # Join with User to populate owner_name
    results = db.query(Startup, User.full_name).join(User, Startup.owner_id == User.id).filter(Startup.is_public == True).order_by(Startup.created_at.desc()).all()
    
    out = []
    for startup, owner_name in results:
        s_dict = {
            "id": startup.id,
            "title": startup.title,
            "description": startup.description,
            "category": startup.category,
            "stage": startup.stage,
            "team_size": startup.team_size,
            "is_public": startup.is_public,
            "required_roles": startup.required_roles,
            "tech_stack": startup.tech_stack,
            "create_room": startup.create_room,
            "owner_id": startup.owner_id,
            "owner_name": owner_name,
            "created_at": startup.created_at,
            "updated_at": startup.updated_at
        }
        out.append(s_dict)
    return out

@router.get("/user/{user_id}", response_model=List[StartupResponse])
def get_user_startups(user_id: int, db: Session = Depends(get_db)):
    results = db.query(Startup, User.full_name).join(User, Startup.owner_id == User.id).filter(Startup.owner_id == user_id).order_by(Startup.created_at.desc()).all()
    
    out = []
    for startup, owner_name in results:
        s_dict = {
            "id": startup.id,
            "title": startup.title,
            "description": startup.description,
            "category": startup.category,
            "stage": startup.stage,
            "team_size": startup.team_size,
            "is_public": startup.is_public,
            "required_roles": startup.required_roles,
            "tech_stack": startup.tech_stack,
            "create_room": startup.create_room,
            "owner_id": startup.owner_id,
            "owner_name": owner_name,
            "created_at": startup.created_at,
            "updated_at": startup.updated_at
        }
        out.append(s_dict)
    return out

@router.post("/request", response_model=JoinRequestResponse)
def send_join_request(req_data: JoinRequestCreate, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    # Verify startup exists
    startup = db.query(Startup).filter(Startup.id == req_data.startup_id).first()
    if not startup:
        raise HTTPException(status_code=404, detail="Startup not found")

    # Prevent owner from requesting to join their own startup
    if startup.owner_id == current_user.id:
        raise HTTPException(status_code=400, detail="You are the owner of this startup.")

    # Check for existing pending request
    existing_req = db.query(JoinRequest).filter(
        JoinRequest.startup_id == req_data.startup_id,
        JoinRequest.requester_id == current_user.id,
        JoinRequest.status == "pending"
    ).first()
    
    if existing_req:
        raise HTTPException(status_code=400, detail="You already have a pending request for this startup.")

    # Create join request
    new_req = JoinRequest(
        startup_id=req_data.startup_id,
        requester_id=current_user.id,
        message=req_data.message,
        status="pending"
    )
    db.add(new_req)
    db.commit()
    db.refresh(new_req)
    
    return {
        "id": new_req.id,
        "startup_id": new_req.startup_id,
        "startup_title": startup.title,
        "requester_id": new_req.requester_id,
        "requester": current_user,
        "status": new_req.status,
        "message": new_req.message,
        "created_at": new_req.created_at,
        "updated_at": new_req.updated_at
    }

@router.get("/requests", response_model=List[JoinRequestResponse])
def get_incoming_requests(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    # Fetch all startups owned by this user
    my_startups = db.query(Startup).filter(Startup.owner_id == current_user.id).all()
    my_startup_ids = [s.id for s in my_startups]
    
    if not my_startup_ids:
        return []

    # Get pending requests for current user's startups
    requests = db.query(JoinRequest).filter(
        JoinRequest.startup_id.in_(my_startup_ids),
        JoinRequest.status == "pending"
    ).order_by(JoinRequest.created_at.desc()).all()
    
    out = []
    for r in requests:
        startup = next((s for s in my_startups if s.id == r.startup_id), None)
        startup_title = startup.title if startup else "Unknown Startup"
        
        out.append({
            "id": r.id,
            "startup_id": r.startup_id,
            "startup_title": startup_title,
            "requester_id": r.requester_id,
            "requester": r.requester,
            "status": r.status,
            "message": r.message,
            "created_at": r.created_at,
            "updated_at": r.updated_at
        })
    return out

@router.post("/requests/{request_id}/accept")
def accept_join_request(request_id: int, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    req = db.query(JoinRequest).filter(JoinRequest.id == request_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")
        
    # Verify authorization
    startup = db.query(Startup).filter(Startup.id == req.startup_id).first()
    if not startup or startup.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to manage this request")
        
    req.status = "accepted"
    db.commit()
    return {"message": "Request accepted successfully"}

@router.post("/requests/{request_id}/reject")
def reject_join_request(request_id: int, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    req = db.query(JoinRequest).filter(JoinRequest.id == request_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")
        
    # Verify authorization
    startup = db.query(Startup).filter(Startup.id == req.startup_id).first()
    if not startup or startup.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to manage this request")
        
    req.status = "rejected"
    db.commit()
    return {"message": "Request rejected successfully"}

@router.get("/my-requests")
def get_my_sent_requests(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    requests = db.query(JoinRequest).filter(JoinRequest.requester_id == current_user.id).all()
    return {r.startup_id: r.status for r in requests}
