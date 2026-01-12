from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.experience_machine import ExperienceMachine
from app.schemas.experience_machine import ExperienceMachineCreate, ExperienceMachineOut

router = APIRouter(prefix="/experiences", tags=["Experience-Machine"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/{experiment_id}/machines", response_model=ExperienceMachineOut)
def add_machine_to_experience(
    experiment_id: int,
    payload: ExperienceMachineCreate,
    db: Session = Depends(get_db),
):
    link = ExperienceMachine(
        experiment_id=experiment_id,
        **payload.dict()
    )
    db.add(link)
    db.commit()
    db.refresh(link)
    return link
