from pydantic import BaseModel
from typing import Optional

class MachineCreate(BaseModel):
    manufacturer: Optional[str] = None
    model: str
    machine_type: Optional[str] = None

class MachineOut(MachineCreate):
    machine_id: int

    class Config:
        orm_mode = True
