# Entry point for the FastAPI
from fastapi import FastAPI

from app.database import engine, Base
from app.models import article, experience, donnee
from app.routes import articles, experiences, files, donnees

app = FastAPI(title="Dosimetry Database API")

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
