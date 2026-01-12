from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.detector import Detector
from app.schemas.detector import DetectorCreate

router = APIRouter(prefix="/detectors", tags=["Detectors"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/")
def create_detector(detector: DetectorCreate, db: Session = Depends(get_db)):
    db_detector = Detector(**detector.dict())
    db.add(db_detector)
    db.commit()
    db.refresh(db_detector)
    return db_detector

@router.get("/")
def list_detectors(db: Session = Depends(get_db)):
    return db.query(Detector).all()
