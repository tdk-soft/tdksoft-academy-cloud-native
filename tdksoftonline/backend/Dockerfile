# --- Stage 1: Builder ---
FROM python:3.10-slim AS builder

# Prevent Python from writing .pyc files and enable buffering
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies for some Python packages (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies in a local folder
COPY backend/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# --- Stage 2: Runtime (Final Image) ---
FROM python:3.10-slim

WORKDIR /app

# Copy only the installed packages from the builder
COPY --from=builder /install /usr/local

# Copy the application code
COPY backend/app ./app
# Copy the frontend static files (since FastAPI serves them)
COPY frontend ./frontend


# Create a non-privileged user for security (Google Best Practice)
RUN adduser --disabled-password --gecos "" tdkuser
USER tdkuser

# Documentation purpose
EXPOSE 8000

# Start the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]