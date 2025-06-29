from fastapi import FastAPI
from routers import main_router

app = FastAPI(title="users API")
app.include_router(main_router.router)

@app.get("/health")
def health_check():
    return {"status": "active", "app": "users"}
