from fastapi import FastAPI
from routers import main_router

app = FastAPI(title="{APP_NAME} API")
app.include_router(main_router.router)

@app.get("/health")
def health_check():
    return {"status": "active", "app": "{APP_NAME}"}
