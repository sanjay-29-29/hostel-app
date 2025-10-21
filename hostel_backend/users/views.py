from django.contrib.auth import get_user_model
import rest_framework.generics as rest_generics
from rest_framework.response import Response

from users.permissions import IsWarden
import users.serializer as users_serializer


class CreateUserView(rest_generics.CreateAPIView):
    serializer_class = users_serializer.UserCreateSerializer
    permission_classes = []


class RetrieveAndUpdateUserView(rest_generics.RetrieveUpdateAPIView):
    queryset = get_user_model().objects.all()

    def get_serializer_class(self):
        if self.request.method in ["PUT", "PATCH"]:
            if self.request.user.role == get_user_model().Role.WARDEN:
                return users_serializer.FullUserUpdateSerializer
            return users_serializer.PartialUserUpdateSerializer
        return users_serializer.UserRetrieveSerializer

    def get_object(self):
        if self.request.user.role == get_user_model().Role.WARDEN:
            return super().get_object()
        return self.request.user

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
