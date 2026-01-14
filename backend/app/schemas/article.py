from pydantic import BaseModel, Field, validator
from typing import Optional

class ArticleCreate(BaseModel):
    title: str = Field(..., min_length=1)
    authors: Optional[str] = Field(..., min_length=1)
    doi: str = Field(..., min_length=1)

    @validator("doi")
    def doi_format(cls, v):
        if "/" not in v:
            raise ValueError("Invalid DOI format")
        return v

class ArticleOut(ArticleCreate):
    article_id: int

    class Config:
        orm_mode = True
