from pydantic import BaseModel, EmailStr

class ContactMessage(BaseModel):
    """
    Data model for contact form submissions using Pydantic for strict validation.
    """
    full_name: str
    email: EmailStr
    subject: str
    message: str
