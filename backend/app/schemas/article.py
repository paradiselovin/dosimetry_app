import re
from pydantic import BaseModel, Field, validator
from typing import Optional

class ArticleCreate(BaseModel):
    title: str = Field(..., min_length=1)
    authors: Optional[str] = Field(..., min_length=1)
    doi: str = Field(..., min_length=1)

    @validator("doi")
    def doi_format(cls, v):
        pattern = r"^10\.[^/]+/.+$"
        if not re.match(pattern, v):
            raise ValueError("Invalid DOI format (expected: 10.xxxx/xxxx)")
        return v

class ArticleOut(ArticleCreate):
    article_id: int

    class Config:
        orm_mode = True
