import typing
from geoalchemy2.types import Geography
from sqlalchemy import Column, create_engine
from cockroachdb.sqlalchemy.dialect import UUID
from sqlalchemy.sql.functions import func
from sqlalchemy.sql.sqltypes import ARRAY, DateTime, String, Float
from sqlalchemy.ext.declarative import declarative_base
from geoalchemy2 import Geometry
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
    coords: Geography
    coords = Column(Geography("POINT", srid=4326))
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
