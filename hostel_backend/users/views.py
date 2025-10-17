from django.contrib.auth import get_user_model
from rest_framework import permissions
from rest_framework.generics import CreateAPIView 

from users.serializer import UserCreateSerializer


class CreateUserView(CreateAPIView):
    model = get_user_model() 
    serializer_class = UserCreateSerializer 
