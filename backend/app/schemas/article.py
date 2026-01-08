from pydantic import BaseModel

class ArticleCreate(BaseModel):
    article_id: int
    title: str
    doi: str