from sqlalchemy import Column, Integer, String, ForeignKey
from app.database import Base

class Donnee(Base):
    __tablename__ = "donnees"

    data_id = Column(Integer, primary_key=True, index=True)
    experiment_id = Column(Integer, ForeignKey("experiences.experiment_id"), nullable=False)

    data_type = Column(String, nullable=False)      
    unit = Column(String)                           
    file_format = Column(String)                   
    file_path = Column(String, nullable=False)

    description = Column(String)
