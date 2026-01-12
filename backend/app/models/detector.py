from sqlalchemy import Column, Integer, String
from app.database import Base

class Detector(Base):
    __tablename__ = "detectors"

    detector_id = Column(Integer, primary_key=True)
    detector_type = Column(String)
    model = Column(String)
    manufacturer = Column(String)
