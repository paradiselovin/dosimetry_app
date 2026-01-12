from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.experience_phantom import ExperiencePhantom
from app.schemas.experience_phantom import ExperiencePhantomCreate, ExperiencePhantomOut

router = APIRouter(prefix="/experiences", tags=["Experience-Phantom"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/{experiment_id}/phantoms", response_model=ExperiencePhantomOut)
def add_phantom_to_experience(
    experiment_id: int,
    payload: ExperiencePhantomCreate,
    db: Session = Depends(get_db),
):
    link = ExperiencePhantom(
        experiment_id=experiment_id,
        phantom_id=payload.phantom_id
    )
    db.add(link)
    db.commit()
    db.refresh(link)
    return link
