import typing
from sqlalchemy import Column, create_engine
from cockroachdb.sqlalchemy.dialect import UUID
from sqlalchemy.sql.functions import func
from sqlalchemy.sql.sqltypes import ARRAY, DateTime, String
from sqlalchemy.ext.declarative import declarative_base
from dataclasses import dataclass

import uuid

from get_secrets import get_secret

Base = declarative_base()


@dataclass
class AnimalSighting(Base):
    __tablename__ = "animal_sightings"
    id: UUID
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    location: str
    location = Column(String)
    coords: typing.List[float]
    coords = Column(ARRAY(Float, as_tuple=True))
    images: typing.List[str]
    images = Column(ARRAY(String))
    animals: typing.List[str]
    animals = Column(ARRAY(String))
    poster = str
    poster = Column(String)
    timestamp = DateTime
    timestamp = Column(DateTime(timezone=True), server_default=func.now())

    def as_dict(self):
        return {c.name: str(getattr(self, c.name)) for c in self.__table__.columns}


engine = create_engine(get_secret("cockroachdb-url"))

Base.metadata.create_all(engine)
