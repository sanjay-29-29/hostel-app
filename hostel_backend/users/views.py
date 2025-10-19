from django.contrib.auth import get_user_model
import rest_framework.generics as rest_generics
from rest_framework.response import Response

from users.permissions import IsWarden
import users.serializer as users_serializer


class CreateUserView(rest_generics.CreateAPIView):
    serializer_class = users_serializer.UserCreateSerializer
    permission_classes = [IsWarden]


class RetrieveAndUpdateUserView(rest_generics.RetrieveUpdateAPIView):
    queryset = get_user_model().objects.all()
    serializer_class = users_serializer.UserRetrieveSerializer

    def get_serializer_class(self):
        if self.request.method in ["PUT", "PATCH"]:
            return users_serializer.UserUpdateSerializer
        return users_serializer.UserRetrieveSerializer

    def get_object(self):
        return self.request.user

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
