# models/article.py
from sqlalchemy import Column, Integer, String
from app.database import Base

class Article(Base):
    __tablename__ = "articles"

    article_id = Column(Integer, primary_key=True)
    title = Column(String)
    doi = Column(String, unique=True)