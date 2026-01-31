from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy.exc import DatabaseError

from app.database import SessionLocal
from app.models.experience import Experience
from app.models.experience_machine import ExperienceMachine
from app.models.experience_phantom import ExperiencePhantom
from app.models.experience_detector import ExperienceDetector
from app.models.article import Article
from app.schemas.experience import ExperienceCreate

router = APIRouter(prefix="/experiences", tags=["Experiences"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", status_code=status.HTTP_201_CREATED)
def create_experience(experience: ExperienceCreate, db: Session = Depends(get_db)):

    # Verifying that the article exists in the database
    article = db.query(Article).filter(
        Article.article_id == experience.article_id
    ).first()

    if not article:
        raise HTTPException(status_code=404, detail="Article not found")
    
    db_experience = Experience(
        description=experience.description,
        article_id=experience.article_id
    )
    db.add(db_experience)

    try:
        db.commit()
    except DatabaseError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Database Error"
        )
    
    db.refresh(db_experience)
    return db_experience

@router.get("/")
def list_experiences(db: Session = Depends(get_db)):
    return db.query(Experience).all()

@router.get("/{experiment_id}/summary")
def get_experiment_summary(experiment_id: int, db: Session = Depends(get_db)):
    return {
        "machines": db.query(ExperienceMachine).filter_by(experiment_id=experiment_id).all(),
        "phantoms": db.query(ExperiencePhantom).filter_by(experiment_id=experiment_id).all(),
        "detectors": db.query(ExperienceDetector).filter_by(experiment_id=experiment_id).all(),
    }
