from django.urls import path, include
from rest_framework.routers import DefaultRouter

import users.views as users_views

router = DefaultRouter()

router.register(r"users", users_views.CreateUpdateUserView, basename="user")

urlpatterns = [
    path("token/", users_views.UserLoginView.as_view()),
    path(
        "users/",
        include(
            [
                path("all/", users_views.SearchAllUsersView.as_view()),
                path("create-info/", users_views.CreateUserInfoGetView.as_view()),
                path("forgot-password/", users_views.PasswordResetOTPView.as_view())
            ]
        ),
    ),
]

urlpatterns += router.urls
