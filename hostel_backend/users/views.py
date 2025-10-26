from django.contrib.auth import get_user_model
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets
from rest_framework.authtoken.models import Token
import rest_framework.generics as rest_generics
from rest_framework.response import Response
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.views import APIView

from hostels.models import Hostel
from hostels.serializers import HostelDropdownSerializer
from users.filters import UserFilter
from users.models import Role
from users.permissions import IsWarden
import users.serializers as users_serializer


class UserLoginView(ObtainAuthToken):

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(
            data=request.data,
            context={"request": request},
        )
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data["user"]

        token, created = Token.objects.get_or_create(user=user)

        user_data = users_serializer.FetchAllUserSerializer(user).data

        return Response(
            {
                "token": token.key,
                **user_data,
            },
        )


class SearchAllUsersView(rest_generics.ListAPIView):

    permission_classes = []
    serializer_class = users_serializer.FetchAllUserSerializer
    queryset = get_user_model().objects.all()

    def get_queryset(self):
        return super().get_queryset()


class CreateUpdateUserView(viewsets.ModelViewSet):

    permission_classes = []
    queryset = get_user_model().objects.all()

    def get_serializer_class(self):
        if self.action == "update" or self.action == "partial_update":
            return users_serializer.UserUpdateSerializer
        return users_serializer.UserCreateSerializer


class CreateUserInfoGetView(APIView):

    authentication_classes = []
    permission_classes = []

    def get(self, request, *args, **kargs):
        hostels = Hostel.objects.all()
        roles = Role.objects.all()

        hostel_data = HostelDropdownSerializer(hostels, many=True).data
        role_data = users_serializer.RoleDropdownSerializer(roles, many=True).data

        return Response({"roles": role_data, "hostels": hostel_data})
