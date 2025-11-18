import random
from django.contrib.auth import get_user_model
from django.db.models import Prefetch
from rest_framework import viewsets
from rest_framework import status
from rest_framework.authtoken.models import Token
import rest_framework.generics as rest_generics
from rest_framework.response import Response
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.views import APIView

from hostels.models import Hostel
from hostels.serializers import HostelDropdownSerializer
from users.filters import UserFilter
from users.models import OTP, Role
from users.permissions import IsWarden
import users.serializers as users_serializer
from wastes.models import Kitchen, Timing
from wastes.serializers import KitchenSerializer, TimingSerializer


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
    queryset = get_user_model().objects.prefetch_related(
        Prefetch(
            "hostels__kitchen_set",
            queryset=Kitchen.objects.all(),
            to_attr="kitchens",
        )
    )

    def get_queryset(self):
        if self.request.user.role.name == "Admin":
            return self.queryset
        return self.queryset.filter(
            hostels__name__in=[
                hostel.name for hostel in self.request.user.hostels.all()
            ]
        )


class CreateUpdateUserView(viewsets.ModelViewSet):

    permission_classes = []
    queryset = get_user_model().objects.all()

    def get_serializer_class(self):
        if self.action == "update" or self.action == "partial_update":
            return users_serializer.UserUpdateSerializer
        if self.action == "create":
            return users_serializer.UserCreateSerializer
        return users_serializer.FetchAllUserSerializer


class CreateUserInfoGetView(APIView):

    authentication_classes = []
    permission_classes = []

    def get(self, request, *args, **kargs):
        hostels = Hostel.objects.all()
        roles = Role.objects.all()
        timings = Timing.objects.all()
        kitchens = Kitchen.objects.all()

        hostel_data = HostelDropdownSerializer(hostels, many=True).data
        role_data = users_serializer.RoleDropdownSerializer(roles, many=True).data
        timing_data = TimingSerializer(timings, many=True).data
        kitchen_data = KitchenSerializer(kitchens, many=True).data

        return Response(
            {
                "roles": role_data,
                "hostels": hostel_data,
                "timings": timing_data,
                "kitchens": kitchen_data,
            }
        )


class PasswordResetOTPView(APIView):

    authentication_classes = []
    permission_classes = []

    def get(self, request, *args, **kwargs):
        serializer = users_serializer.OTPRequestSerializer(data=request.query_params)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data.get("email")
        User = get_user_model()

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response(
                {"detail": "User with provided email not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        OTP.objects.filter(user=user, is_used=False).update(is_used=True)
        otp_code = random.randint(100000, 999999)
        OTP.objects.create(user=user, code=otp_code)

        return Response(
            {"detail": "Password reset OTP sent."}, status=status.HTTP_200_OK
        )

    def post(self, request, *args, **kwargs):
        serializer = users_serializer.UserPasswordResetSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data.get("email")
        code = serializer.validated_data.get("otp")

        data = OTPValidateView.validate_otp(email, code)

        if isinstance(data, Response):
            return data

        user, otp = data

        user.set_password(serializer.validated_data.get("new_password"))
        user.save()

        otp.is_used = True
        otp.save()

        return Response(
            {"detail": "Password has been reset successfully."},
            status=status.HTTP_200_OK,
        )


class OTPValidateView(APIView):
    authentication_classes = []
    permission_classes = []

    @staticmethod
    def validate_otp(email, otp):
        User = get_user_model()

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response(
                {"detail": "User with provided email not found."},
                status=status.HTTP_404_NOT_FOUND,
            )

        try:
            otp = OTP.objects.get(user=user, code=otp, is_used=False)
        except OTP.DoesNotExist:
            return Response(
                {"detail": "Invalid or used OTP."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        return user, otp

    def post(self, request, *args, **kwargs):
        serializer = users_serializer.OTPValidateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data.get("email")
        otp = serializer.validated_data.get("otp")

        is_valid = OTPValidateView.validate_otp(email, otp)

        if isinstance(is_valid, Response):
            return is_valid

        return Response(
            {"detail": "OTP is valid."},
            status=status.HTTP_200_OK,
        )
