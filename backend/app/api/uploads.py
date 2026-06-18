from fastapi import APIRouter
from fastapi import File
from fastapi import UploadFile
from fastapi import HTTPException

from app.services.s3_service import upload_file

from fastapi import Depends

from app.dependencies.auth import get_current_user

from app.models.user import User

from app.services.sns_service import publish_event

router = APIRouter(
    prefix="/uploads",
    tags=["Uploads"]
)


@router.post("/profile-picture")
def upload_profile_picture(
    file: UploadFile = File(...),
    current_user: User = Depends(
        get_current_user
    )
):

    if not file.content_type.startswith(
        "image/"
    ):

        raise HTTPException(
            status_code=400,
            detail="Image file required"
        )

    key = upload_file(
        file,
        "profile-pictures"
    )

publish_event(

    event_type="file_uploaded",

    payload={

        "file_type": "profile-picture",

        "user_email": current_user.email,

        "user_name": current_user.full_name,

        "s3_key": key

    }

)

    return {

        "message": "Profile picture uploaded",

        "s3_key": key

    }


@router.post("/project-image")
def upload_project_image(
    file: UploadFile = File(...),
    current_user: User = Depends(
        get_current_user
    )
):

    if not file.content_type.startswith(
        "image/"
    ):

        raise HTTPException(
            status_code=400,
            detail="Image file required"
        )

    key = upload_file(
        file,
        "project-images"
    )

publish_event(

    event_type="file_uploaded",

    payload={

        "file_type": "project-image",

        "user_email": current_user.email,

        "user_name": current_user.full_name,

        "s3_key": key

    }

)

    return {

        "message": "Project image uploaded",

        "s3_key": key

    }


@router.post("/resume")
def upload_resume(
    file: UploadFile = File(...),
    current_user: User = Depends(
        get_current_user
    )
):

    key = upload_file(
        file,
        "resumes"
    )

publish_event(

    event_type="file_uploaded",

    payload={

        "file_type": "resume",

        "user_email": current_user.email,

        "user_name": current_user.full_name,

        "s3_key": key

    }

)

    return {

        "message": "Resume uploaded",

        "s3_key": key

    }
