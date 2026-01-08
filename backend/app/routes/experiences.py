from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.experience import Experience
from app.models.article import Article
from app.schemas.experience import ExperienceCreate

router = APIRouter(prefix="/experiences", tags=["Experiences"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/")
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
    db.commit()
    db.refresh(db_experience)
    return db_experience

@router.get("/")
def list_experiences(db: Session = Depends(get_db)):
    return db.query(Experience).all()
