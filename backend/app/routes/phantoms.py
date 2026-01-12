from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.phantom import Phantom
from app.schemas.phantom import PhantomCreate

router = APIRouter(prefix="/phantoms", tags=["Phantoms"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/")
def create_phantom(phantom: PhantomCreate, db: Session = Depends(get_db)):
    db_phantom = Phantom(**phantom.dict())
    db.add(db_phantom)
    db.commit()
    db.refresh(db_phantom)
    return db_phantom

@router.get("/")
def list_phantoms(db: Session = Depends(get_db)):
    return db.query(Phantom).all()
