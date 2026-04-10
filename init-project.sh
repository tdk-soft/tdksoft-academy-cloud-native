#!/bin/bash

# TDK Soft Consulting - Project Initializer
# Architecture: FastAPI (Backend) + Static/Modern (Frontend)

PROJECT_NAME="tdksoftonline"
mkdir -p $PROJECT_NAME/{backend/app/{api,core,models,services},frontend/{static/{css,js,assets/{vids,img,fonts}},templates},nginx}

cd $PROJECT_NAME

# --- BACKEND: Models ---
cat <<EOF > backend/app/models/contact.py
from pydantic import BaseModel, EmailStr

class ContactMessage(BaseModel):
    """
    Data model for contact form submissions using Pydantic for strict validation.
    """
    full_name: str
    email: EmailStr
    subject: str
    message: str
EOF

# --- BACKEND: API Routes ---
cat <<EOF > backend/app/api/contact_router.py
from fastapi import APIRouter, HTTPException
from app.models.contact import ContactMessage

router = APIRouter()

@router.post("/contact")
async def send_contact(message: ContactMessage):
    """
    Endpoint to handle contact form submissions.
    OOP Approach: Logic should be delegated to a Service layer in production.
    """
    try:
        # Business logic would go here (e.g., sending an email)
        return {"status": "success", "detail": f"Message received from {message.full_name}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
EOF

# --- BACKEND: Main ---
cat <<EOF > backend/app/main.py
import uvicorn
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from app.api import contact_router

app = FastAPI(title="TDK Soft Consulting API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(contact_router.router, prefix="/api/v1")
app.mount("/", StaticFiles(directory="../frontend/static", html=True), name="static")

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
EOF

# --- FRONTEND: HTML ---
cat <<EOF > frontend/static/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TDK Soft Consulting | IT Solutions</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header><h1>TDK Soft Consulting</h1></header>
    <form id="contactForm">
        <input type="text" id="full_name" placeholder="Full Name" required>
        <input type="email" id="email" placeholder="Email" required>
        <input type="text" id="subject" placeholder="Subject" required>
        <textarea id="message" placeholder="Message" required></textarea>
        <button type="submit">Submit</button>
    </form>
    <div id="response"></div>
    <script src="js/main.js"></script>
</body>
</html>
EOF

# --- FRONTEND: JS ---
cat <<EOF > frontend/static/js/main.js
document.getElementById('contactForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = {
        full_name: document.getElementById('full_name').value,
        email: document.getElementById('email').value,
        subject: document.getElementById('subject').value,
        message: document.getElementById('message').value
    };
    const res = await fetch('/api/v1/contact', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(data)
    });
    const result = await res.json();
    document.getElementById('response').innerText = result.detail;
});
EOF

# --- CONFIG: .gitignore ---
cat <<EOF > .gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
.venv/
env/
.env

# Web
node_modules/
.DS_Store

# Docker
docker-compose.override.yml
EOF

# --- CONFIG: README.md ---
cat <<EOF > README.md
# TDK Soft Consulting - Web Platform

Professional decoupled architecture using **FastAPI** (Backend) and **Clean HTML/JS** (Frontend).

## Architecture
- **Backend**: Python 3.10+, FastAPI, Pydantic.
- **Frontend**: Responsive HTML5/CSS3/Vanilla JS (Ready for React/Angular migration).
- **Deployment**: Docker & Nginx.

## Setup
1. Create virtual env: \`python -m venv venv\`
2. Install deps: \`pip install fastapi uvicorn pydantic[email]\`
3. Run: \`cd backend && python -m app.main\`
EOF

echo "Project TDK Soft Consulting generated successfully!"