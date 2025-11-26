from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from app.schemas.user import UserResponse
from app.schemas.book import BookResponse


class LoanCreate(BaseModel):
    book_id: int


class LoanResponse(BaseModel):
    id: int
    user_id: int
    book_id: int
    loan_date: datetime
    return_date: Optional[datetime] = None
    due_date: datetime
    is_returned: bool
    created_at: datetime
    user: Optional[UserResponse] = None
    book: Optional[BookResponse] = None

    class Config:
        from_attributes = True


