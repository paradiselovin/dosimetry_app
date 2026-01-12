from sqlalchemy import Column, Integer, String
from app.database import Base

class Machine(Base):
    __tablename__ = "machines"

    machine_id = Column(Integer, primary_key=True, index=True)
    manufacturer = Column(String)
    model = Column(String, nullable=False)
    machine_type = Column(String)  # LINAC, proton…
