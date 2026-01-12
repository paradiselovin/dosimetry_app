from pydantic import BaseModel
from typing import Optional

class PhantomCreate(BaseModel):
    name: str
    phantom_type: Optional[str] = None
    dimensions: Optional[str] = None
    material: Optional[str] = None

class PhantomOut(PhantomCreate):
    phantom_id: int

    class Config:
        orm_mode = True
