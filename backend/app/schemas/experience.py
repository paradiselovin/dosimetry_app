from pydantic import BaseModel

class ExperienceCreate(BaseModel):
    description: str
    article_id: int

class ExperienceOut(ExperienceCreate):
    experiment_id: int

    class Config:
        orm_mode = True
