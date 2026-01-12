from sqlalchemy import Column, Integer, String
from app.database import Base

class Phantom(Base):
    __tablename__ = "phantoms"

    phantom_id = Column(Integer, primary_key=True)
    name = Column(String)
    phantom_type = Column(String)
    dimensions = Column(String)
    material = Column(String)
