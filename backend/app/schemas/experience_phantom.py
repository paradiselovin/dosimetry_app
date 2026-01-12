from pydantic import BaseModel

class ExperiencePhantomCreate(BaseModel):
    phantom_id: int

class ExperiencePhantomOut(ExperiencePhantomCreate):
    experiment_id: int

    class Config:
        orm_mode = True
