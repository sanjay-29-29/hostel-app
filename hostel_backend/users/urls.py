from rest_framework.authtoken.views import obtain_auth_token
from django.urls import path
from rest_framework.generics import RetrieveAPIView

import users.views as users_views

urlpatterns = [
    path("login/", obtain_auth_token),
    path("register/", users_views.CreateUserView.as_view()),
    path("user/", users_views.RetrieveAndUpdateUserView.as_view()),
]
