from sqlalchemy import Column, Integer, String
from app.database import Base

class Article(Base):
    __tablename__ = "articles"

    article_id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    authors = Column(String)
    doi = Column(String, unique=True)
