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
