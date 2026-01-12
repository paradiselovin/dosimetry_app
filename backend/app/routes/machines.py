from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.machine import Machine
from app.schemas.machine import MachineCreate

router = APIRouter(prefix="/machines", tags=["Machines"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/")
def create_machine(machine: MachineCreate, db: Session = Depends(get_db)):
    db_machine = Machine(**machine.dict())
    db.add(db_machine)
    db.commit()
    db.refresh(db_machine)
    return db_machine

@router.get("/")
def list_machines(db: Session = Depends(get_db)):
    return db.query(Machine).all()
