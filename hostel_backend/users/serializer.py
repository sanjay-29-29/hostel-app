from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers

from hostels.models import Hostel
from users.models import HostelMembership


class UserCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    hostels = serializers.PrimaryKeyRelatedField(
        many=True, queryset=Hostel.objects.all(), source="hostel"
    )

    def create(self, validated_data):
        hostels = validated_data.pop("hostel")
        user = get_user_model().objects.create_user(
            email=validated_data["email"],
            password=validated_data["password"],
            phone_number=validated_data["phone_number"],
            first_name=validated_data["first_name"],
            last_name=validated_data["last_name"],
        )
        hostel_membership = [
            HostelMembership(user=user, hostel=hostel) for hostel in hostels
        ]
        HostelMembership.objects.bulk_create(hostel_membership)
        return user

    class Meta:
        model = get_user_model()
        fields = [
            "first_name",
            "last_name",
            "phone_number",
            "password",
            "email",
            "hostels",
        ]


class UserRetrieveSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "name",
            "phone_number",
        ]


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
    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "phone_number",
            "name",
            "role",
            "date_joined",
            "is_active",
        ]
