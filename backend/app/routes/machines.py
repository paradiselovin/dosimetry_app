from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy.exc import DatabaseError

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

@router.post("/", status_code=status.HTTP_201_CREATED)
def create_machine(machine: MachineCreate, db: Session = Depends(get_db)):

    # Pre-verifying
    existing_machine = db.query(Machine).filter( 
        Machine.manufacturer == machine.manufacturer,
        Machine.model == machine.model,
        Machine.machine_type == machine.machine_type
    ).first()
    if existing_machine:
        raise HTTPException(
            status_code=409,
            detail="Machine already exists"
        )
    
    db_machine = Machine(**machine.dict())
    db.add(db_machine)
    
    try:
        db.commit()
    except DatabaseError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Database Error"
        )

    db.refresh(db_machine)
    return db_machine

@router.get("/")
def list_machines(db: Session = Depends(get_db)):
    return db.query(Machine).all()
