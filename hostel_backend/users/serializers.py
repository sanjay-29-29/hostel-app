from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers

from hostels.models import Hostel
from hostels.serializers import HostelDropdownSerializer
from users.models import HostelMembership, Role
from wastes.models import Kitchen
from wastes.serializers import KitchenSerializer


class UserCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    hostels = serializers.PrimaryKeyRelatedField(
        queryset=Hostel.objects.all(), many=True
    )
    role = serializers.PrimaryKeyRelatedField(queryset=Role.objects.all())

    def create(self, validated_data):
        hostels = validated_data.pop("hostels", [])
        user = get_user_model().objects.create_user(**validated_data)
        hostel_memberships = []
        hostel_memberships = [
            HostelMembership(hostel=hostel, user=user) for hostel in hostels
        ]
        HostelMembership.objects.bulk_create(hostel_memberships)
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


class UserUpdateSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(write_only=True, required=False)
    password = serializers.CharField(write_only=True, required=False)
    role = serializers.PrimaryKeyRelatedField(queryset=Role.objects.all())

    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "phone_number",
            "name",
            "role",
            "password",
            "confirm_password",
            "is_active",
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


class FetchAllUserSerializer(serializers.ModelSerializer):
    role = RoleDropdownSerializer()
    hostels = HostelDropdownSerializer(many=True)
    kitchens = serializers.SerializerMethodField()

    class Meta:
        model = get_user_model()
        fields = [
            "id",
            "email",
            "phone_number",
            "name",
            "role",
            "date_joined",
            "is_active",
            "is_new",
            "kitchens",
            "hostels",
        ]

    def get_kitchens(self, obj):
        """Get all kitchens associated with user through their hostels"""
        kitchens = Kitchen.objects.filter(hostels__in=obj.hostels.all()).distinct()
        serializer = KitchenSerializer(kitchens, many=True)
        return serializer.data

    def get_role(self, obj):
        return obj.role.name


class UserPassswordResetSerilizer(serializers.Serializer):
    email = serializers.EmailField()
