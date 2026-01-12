from sqlalchemy import Column, Integer, ForeignKey
from app.database import Base

class ExperiencePhantom(Base):
    __tablename__ = "experience_phantom"

    experiment_id = Column(Integer, ForeignKey("experiences.experiment_id"), primary_key=True)
    phantom_id = Column(Integer, ForeignKey("phantoms.phantom_id"), primary_key=True)
