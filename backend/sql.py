from sqlalchemy import Column
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql.functions import func
from sqlalchemy.sql.sqltypes import ARRAY, DateTime, String
from sqlalchemy.ext.declarative import declarative_base

from flask_sqlalchemy import SQLAlchemy

import uuid

Base = declarative_base()


class AnimalSighting(Base):
    __tablename__ = "animal_sightings"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    location = Column(String)
    images = Column(ARRAY(String))
    animals = Column(ARRAY(String))
    poster = Column(String)
    timestamp = Column(DateTime(timezone=True), server_default=func.now())
