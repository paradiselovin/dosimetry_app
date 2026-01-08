from pydantic import BaseModel

class DonneeCreate(BaseModel):
    data_type: str
    unit: str | None = None
    file_format: str
    description: str | None = None

class DonneeOut(DonneeCreate):
    data_id: int
    experiment_id: int
    file_path: str

    class Config:
        orm_mode = True
