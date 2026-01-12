from pydantic import BaseModel
from typing import Optional

class ExperienceMachineCreate(BaseModel):
    machine_id: int
    energy: Optional[str] = None
    collimation: Optional[str] = None
    settings: Optional[str] = None

class ExperienceMachineOut(ExperienceMachineCreate):
    experiment_id: int

    class Config:
        orm_mode = True
