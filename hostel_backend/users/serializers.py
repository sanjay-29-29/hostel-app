from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers

from hostels.models import Hostel
from hostels.serializers import HostelDropdownSerializer
from users.models import HostelMembership, Role


class UserCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    hostels = serializers.PrimaryKeyRelatedField(
        many=True, queryset=Hostel.objects.all(), source="hostel"
    )
    role = serializers.PrimaryKeyRelatedField(queryset=Role.objects.all())

    def create(self, validated_data):
        hostels = validated_data.pop("hostel")
        user = get_user_model().objects.create_user(
            email=validated_data["email"],
            password=validated_data["password"],
            phone_number=validated_data["phone_number"],
            name=validated_data["name"],
            role=validated_data["role"],
        )
        hostel_membership = [
            HostelMembership(user=user, hostel=hostel) for hostel in hostels
        ]
        HostelMembership.objects.bulk_create(hostel_membership)
        return user

    class Meta:
        model = get_user_model()
        fields = [
            "name",
            "phone_number",
            "password",
            "email",
            "role",
            "hostels",
        ]


class RoleDropdownSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ["id", "name"]


class PartialUserUpdateSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(write_only=True, required=False)
    password = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "phone_number",
            "name",
            "password",
            "confirm_password",
        ]

    def validate(self, attrs):
        password = attrs.get("password", None)
        confirm_password = attrs.pop("confirm_password", None)

        if password:
            if password != confirm_password:
                raise serializers.ValidationError(
                    {"confirm_password": "Passwords do not match."}
                )

        return attrs

    def update(self, instance, validated_data):
        password = validated_data.pop("password", None)

        instance = super().update(instance, validated_data)

        if password:
            instance.set_password(password)
            instance.save()

        return instance


class FullUserUpdateSerializer(PartialUserUpdateSerializer):
    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "phone_number",
            "name",
            "password",
            "confirm_password",
            "role",
        ]


class FetchAllUserSerializer(serializers.ModelSerializer):
    role = serializers.SerializerMethodField()
    hostel = HostelDropdownSerializer(many=True)

    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "phone_number",
            "name",
            "role",
            "date_joined",
            "is_active",
            "is_new",
            "hostel",
        ]

    def get_role(self, obj):
        return obj.role.name
