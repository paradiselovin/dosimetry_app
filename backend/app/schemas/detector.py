from pydantic import BaseModel
from typing import Optional

class DetectorCreate(BaseModel):
    detector_type: str
    model: Optional[str] = None
    manufacturer: Optional[str] = None

class DetectorOut(DetectorCreate):
    detector_id: int

    class Config:
        orm_mode = True
