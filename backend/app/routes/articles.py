from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.article import Article
from app.schemas.article import ArticleCreate

router = APIRouter(prefix="/articles", tags=["Articles"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/")
def create_article(article: ArticleCreate, db: Session = Depends(get_db)):
    db_article = Article(**article.dict())
    db.add(db_article)
    db.commit()
    db.refresh(db_article)
    return db_article

@router.get("/")
def list_articles(db: Session = Depends(get_db)):
    return db.query(Article).all()
