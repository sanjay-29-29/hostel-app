from django.contrib.auth import get_user_model
from rest_framework.authtoken.models import Token
import rest_framework.generics as rest_generics
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response
from rest_framework.authtoken.views import ObtainAuthToken
from django_filters.rest_framework import DjangoFilterBackend

from users.filters import UserFilter
from users.permissions import IsWarden
import users.serializer as users_serializer


class UserLoginView(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(
            data=request.data, context={"request": request}
        )
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data["user"]

        token, created = Token.objects.get_or_create(user=user)

        return Response(
            {
                "token": token.key,
                "email": user.email,
                "name": user.name,
                "phone_number": user.phone_number,
                "role": user.role,
                "is_active": user.is_active,
                "date_joined": user.date_joined,
            }
        )


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


class SearchAllUsersView(rest_generics.ListAPIView):
    permission_classes = []
    queryset = get_user_model().objects.all()
    filter_backends = [DjangoFilterBackend]
    filterset_class = UserFilter
    serializer_class = users_serializer.FetchAllUserSerializer
