from rest_framework import serializers

from hostels.models import Hostel
from wastes.models import Timing, Waste


class WasteSerializer(serializers.ModelSerializer):
    updated_by = serializers.CharField(source="updated_by.name", read_only=True)
    created_by = serializers.CharField(source="created_by.name", read_only=True)

    class Meta:
        model = Waste
        fields = [
            "id",
            "coffe_waste",
            "food_cooked_waste",
            "student_waste",
            "date",
            "hostel",
            "timing",
            "students_present",
            "updated_by",
            "created_by",
        ]
        read_only_fields = [
            "id",
            "hostel",
        ]


class WasteGetSerializer(serializers.Serializer):
    date = serializers.DateField(required=True)
    hostel = serializers.PrimaryKeyRelatedField(
        queryset=Hostel.objects.all(), required=True
    )
    timing = serializers.PrimaryKeyRelatedField(
        queryset=Timing.objects.all(), required=True
    )


class TimingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Timing
        fields = ["id", "name"]
