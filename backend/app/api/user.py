from fastapi import APIRouter
from fastapi import Depends

from sqlalchemy.orm import Session

from app.dependencies.auth import get_current_user
from app.dependencies.auth import get_db

from app.models.user import User

router = APIRouter(
    prefix="/users",
    tags=["Users"]
)


@router.get("/me")
def get_me(
    current_user: User = Depends(
        get_current_user
    )
):

    return {

        "id": current_user.id,

        "full_name": current_user.full_name,

        "email": current_user.email,

        "profile_picture":
            current_user.profile_picture,

        "bio":
            current_user.bio

    }


@router.put("/me/bio")
def update_bio(

    payload: dict,

    db: Session = Depends(
        get_db
    ),

    current_user: User = Depends(
        get_current_user
    )

):

    current_user.bio = payload["bio"]

    db.commit()

    db.refresh(current_user)

    return {

        "message": "Bio updated"

    }
