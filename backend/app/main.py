# Entry point for the FastAPI
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database import engine, Base
from app.models import (
    article,
    experience,
    donnee,
    detector,
    machine,
    phantom,
    )
from app.routes import (
    articles,
    experiences,
    files,
    donnees,
    detectors,
    experience_detectors,
    machines,
    experience_machines,
    phantoms,
    experience_phantoms
)


app = FastAPI(title="Dosimetry Database API")

# Creating a CORS middleware to adapt configurations from Flutter to FastAPI
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # dev uniquement
    allow_credentials=True,
    allow_methods=["*"],  # IMPORTANT (inclut OPTIONS)
    allow_headers=["*"],
)

# Creating tables
Base.metadata.create_all(bind=engine)

# Creating routers
app.include_router(articles.router)
app.include_router(experiences.router)
app.include_router(files.router)
app.include_router(donnees.router)

@app.get("/")
def root():
    return {"status": "API running"}


from app.routes import (
    machines,
    phantoms,
    detectors,
)

app.include_router(machines.router)
app.include_router(phantoms.router)
app.include_router(detectors.router)
app.include_router(experience_machines.router)
app.include_router(experience_phantoms.router)
app.include_router(experience_detectors.router)
