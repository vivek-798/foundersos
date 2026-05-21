from fastapi import FastAPI
from database.connection import engine
from models import user_model, startup_model, join_request_model

# Create all database tables based on SQLAlchemy models
startup_model.Base.metadata.create_all(bind=engine)

app = FastAPI(title="FoundersOS API")

@app.get("/")
def read_root():
    return {"message": "Welcome to FoundersOS API"}

from routes import auth_routes, user_routes, startup_routes

app.include_router(auth_routes.router, prefix="/api/v1/auth", tags=["Auth"])
app.include_router(user_routes.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(startup_routes.router, prefix="/api/v1/startups", tags=["Startups"])
