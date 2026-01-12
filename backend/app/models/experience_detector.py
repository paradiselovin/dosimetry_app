from sqlalchemy import Column, Integer, ForeignKey, String
from app.database import Base

class ExperienceDetector(Base):
    __tablename__ = "experience_detector"

    experiment_id = Column(Integer, ForeignKey("experiences.experiment_id"), primary_key=True)
    detector_id = Column(Integer, ForeignKey("detectors.detector_id"), primary_key=True)

    position = Column(String)
    depth = Column(String)
    orientation = Column(String)
