from rest_framework.authtoken.views import obtain_auth_token
from django.urls import path

from users.views import CreateUserView

urlpatterns = [
    path('auth/', obtain_auth_token),
    path('register/', CreateUserView.as_view())
]
