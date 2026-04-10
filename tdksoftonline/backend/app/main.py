import os
import logging
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from app.api import contact_router

# 1. Logging Configuration (Standard SRE to monitor Docker operations)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="TDK Soft Academy API",
    description="Backend for TDK Soft Online - Coding for children",
    version="1.1.0",
    docs_url="/api/docs",      # Moved docs to avoid cluttering the root
    redoc_url="/api/redoc"
)

# 2. Path Management
# BASE_DIR is /app
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FRONTEND_PATH = os.path.join(BASE_DIR, "frontend", "static")

# 3. Middlewares (Security & CORS)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In production, replace "*" with your specific domain
    allow_credentials=True,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)

# 4. API Routes Registration (Always BEFORE static files)
app.include_router(contact_router.router, prefix="/api/v1", tags=["Contact"])

# 5. Healthcheck Route (Standard for Kubernetes/k3s)
@app.get("/api/v1/health", tags=["System"])
async def health_check():
    return {"status": "healthy", "version": "1.1.0"}

# 6. Static Files Mounting (The "Catch-all" at the end)
if os.path.exists(FRONTEND_PATH):
    logger.info(f"🚀 Mounting frontend from: {FRONTEND_PATH}")
    app.mount("/", StaticFiles(directory=FRONTEND_PATH, html=True), name="static")
else:
    logger.error(f"❌ Frontend folder not found: {FRONTEND_PATH}")

# Note: In production (Docker), we don't run uvicorn.run() here.
# The Dockerfile's CMD handles the worker.