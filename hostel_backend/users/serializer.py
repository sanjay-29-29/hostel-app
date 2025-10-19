from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers


class UserCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    def create(self, validated_data):
        user = get_user_model().objects.create_user(
            email=validated_data["email"],
            password=validated_data["password"],
            phone_number=validated_data["phone_number"],
            first_name=validated_data["first_name"],
            last_name=validated_data["last_name"],
        )
        return user

    class Meta:
        model = get_user_model()
        fields = [
            "first_name",
            "last_name",
            "phone_number",
            "password",
            "email",
        ]


class UserRetrieveSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "first_name",
            "last_name",
            "phone_number",
        ]


class UserUpdateSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(write_only=True, required=False)
    password = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = get_user_model()
        fields = [
            "email",
            "phone_number",
            "first_name",
            "last_name",
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
            try:
                pass
                # validate_password(password)
            except serializers.ValidationError as e:
                raise serializers.ValidationError({"password": list(e.detail)})

        return attrs

    def update(self, instance, validated_data):
        password = validated_data.pop("password", None)

        instance = super().update(instance, validated_data)

        if password:
            instance.set_password(password)
            instance.save()

        return instance
