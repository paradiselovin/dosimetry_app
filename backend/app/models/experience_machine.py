from sqlalchemy import Column, Integer, ForeignKey, String
from app.database import Base

class ExperienceMachine(Base):
    __tablename__ = "experience_machine"

    experiment_id = Column(
        Integer, ForeignKey("experiences.experiment_id"), primary_key=True
    )
    machine_id = Column(
        Integer, ForeignKey("machines.machine_id"), primary_key=True
    )
    
    energy = Column(String)
    collimation = Column(String)
    settings = Column(String)
