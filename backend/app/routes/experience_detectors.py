from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.experience_detector import ExperienceDetector
from app.schemas.experience_detector import (
    ExperienceDetectorCreate,
    ExperienceDetectorOut,
)

router = APIRouter(prefix="/experiences", tags=["Experience-Detector"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/{experiment_id}/detectors", response_model=ExperienceDetectorOut)
def add_detector_to_experience(
    experiment_id: int,
    payload: ExperienceDetectorCreate,
    db: Session = Depends(get_db),
):
    link = ExperienceDetector(
        experiment_id=experiment_id,
        **payload.dict()
    )
    db.add(link)
    db.commit()
    db.refresh(link)
    return link
