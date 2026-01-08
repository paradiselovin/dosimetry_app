import os
from fastapi import APIRouter, UploadFile, File, Form, Depends
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.donnee import Donnee

router = APIRouter(prefix="/donnees", tags=["Donnees"])

UPLOAD_DIR = "data/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/upload/{experiment_id}")
def upload_donnee(
    experiment_id: int,
    file: UploadFile = File(...),
    data_type: str = Form(...),
    unit: str = Form(None),
    description: str = Form(None),
    db: Session = Depends(get_db),
):
    file_path = f"{UPLOAD_DIR}/{experiment_id}_{file.filename}"

    # Saving the file
    with open(file_path, "wb") as f:
        f.write(file.file.read())

    # Database insertion
    donnee = Donnee(
        experiment_id=experiment_id,
        data_type=data_type,
        unit=unit,
        file_format=file.filename.split(".")[-1],
        file_path=file_path,
        description=description,
    )

    db.add(donnee)
    db.commit()
    db.refresh(donnee)

    return donnee

@router.get("/")
def list_donnees(db: Session = Depends(get_db)):
    return db.query(Donnee).all()
