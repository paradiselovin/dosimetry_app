from sqlalchemy import Column, Integer, String, ForeignKey
from app.database import Base

class Experience(Base):
    __tablename__ = "experiences"

    experiment_id = Column(Integer, primary_key=True, index=True)
    description = Column(String)
    article_id = Column(Integer, ForeignKey("articles.article_id"))
    
