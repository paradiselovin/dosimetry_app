from app.database import engine
from backend.app.models.article import Article

Article.metadata.create_all(bind=engine)