from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.article import Article
from app.schemas.article import ArticleCreate

router = APIRouter(prefix="/articles")

@router.post("/")
def create_article(article: ArticleCreate):
    db = SessionLocal()
    db_article = Article(title=article.title, content=article.content)
    db.add(db_article)
    db.commit()
    db.refresh(db_article)
    return db_article


