from django.db import transaction
from django.forms import fields
from rest_framework import serializers
from datetime import date

from hostels.models import Hostel
from hostels.serializers import HostelDropdownSerializer
from wastes.models import Attendance, Kitchen, Timing, Waste


class AttendanceSerializer(serializers.ModelSerializer):
    hostel_name = serializers.CharField(source="hostel.name", read_only=True)
    hostel_id = serializers.PrimaryKeyRelatedField(
        source="hostel", queryset=Hostel.objects.all(), write_only=True
    )

    class Meta:
        model = Attendance
        fields = [
            "id",
            "hostel_id",
            "hostel_name",
            "students_present",
            "students_absent",
        ]


class WasteCreateAndUpdateSerializer(serializers.ModelSerializer):
    attendances = AttendanceSerializer(many=True, required=True)

    class Meta:
        model = Waste
        fields = [
            "id",
            "date",
            "coffe_waste",
            "food_cooked_waste",
            "student_waste",
            "timing",
            "kitchen",
            "attendances",
        ]

    def validate(self, attrs):
        attrs = super().validate(attrs)
        date_value = attrs.get("date")

        if date_value and date_value > date.today():
            raise serializers.ValidationError({"date": "Date cannot be in the future."})
        return attrs

    def create(self, validated_data):
        attendances_data = validated_data.pop("attendances")

        with transaction.atomic():
            waste = Waste.objects.create(**validated_data)
            attendances = [Attendance.objects.create(**a) for a in attendances_data]
            waste.attendances.set(attendances)

        return waste

    def update(self, instance, validated_data):
        attendances_data = validated_data.pop("attendances", None)

        with transaction.atomic():

            for attr, value in validated_data.items():
                setattr(instance, attr, value)

            instance.save()

        if attendances_data is not None:
            new_attendances = []
            instance.attendances.all().delete()

            for a in attendances_data:
                new_attendances.append(Attendance.objects.create(**a))

            instance.attendances.set(new_attendances)

        return instance


class WasteSerializer(serializers.ModelSerializer):
    updated_by = serializers.CharField(source="updated_by.name", read_only=True)
    created_by = serializers.CharField(source="created_by.name", read_only=True)
    kitchen_name = serializers.CharField(source="kitchen.name", read_only=True)
    timing_name = serializers.CharField(source="timing.name", read_only=True)
    attendances = AttendanceSerializer(many=True)

    class Meta:
        model = Waste
        fields = [
            "id",
            "date",
            "coffe_waste",
            "food_cooked_waste",
            "student_waste",
            "timing",
            "timing_name",
            "kitchen",
            "kitchen_name",
            "attendances",
            "updated_by",
            "created_by",
        ]
        read_only_fields = [
            "id",
            "kitchen_name",
            "timing_name",
        ]
        extra_kwargs = {
            "kitchen": {"write_only": True},
            "timing": {"write_only": True},
        }


class TimingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Timing
        fields = ["id", "name"]


class KitchenSerializer(serializers.ModelSerializer):
    hostels = HostelDropdownSerializer(many=True)

    class Meta:
        model = Kitchen
        fields = ["id", "name", "hostels"]
