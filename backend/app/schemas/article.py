from pydantic import BaseModel
from typing import Optional

class ArticleCreate(BaseModel):
    title: str
    authors: Optional[str] = None
    doi: str

class ArticleOut(ArticleCreate):
    article_id: int

    class Config:
        orm_mode = True
