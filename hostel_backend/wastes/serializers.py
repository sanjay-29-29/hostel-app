from django.db import transaction
from rest_framework import serializers

from hostels.models import Hostel
from wastes.models import Attendance, Timing, Waste


class AttendanceSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=False)
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


class WasteSerializer(serializers.ModelSerializer):
    updated_by = serializers.CharField(source="updated_by.name", read_only=True)
    created_by = serializers.CharField(source="created_by.name", read_only=True)
    hostel_name = serializers.CharField(source="hostel.name", read_only=True)
    timing_name = serializers.CharField(source="timing.name", read_only=True)
    attendances = AttendanceSerializer(many=True, required=False)

    class Meta:
        model = Waste
        fields = [
            "id",
            "coffe_waste",
            "food_cooked_waste",
            "student_waste",
            "date",
            "timing_name",
            "hostel_name",
            "hostel",
            "timing",
            "attendances",
            "updated_by",
            "created_by",
        ]
        read_only_fields = [
            "id",
            "hostel_name",
            "timing_name",
        ]
        extra_kwargs = {
            "hostel": {"write_only": True},
            "timing": {"write_only": True},
        }

    def update(self, instance, validated_data):
        attendance_data = validated_data.pop('attendances', None)
        
        with transaction.atomic():
            # Update main instance
            for attr, value in validated_data.items():
                setattr(instance, attr, value)
            instance.save()

            # If attendance_data is provided, replace all existing attendances
            if attendance_data is not None:
                # Delete all existing attendances for this waste instance
                instance.attendances.all().delete()
                
                # Create new attendances
                errors = []
                for index, attendance_item in enumerate(attendance_data):
                    # Add waste instance to attendance data
                    attendance_serializer = AttendanceSerializer(
                        data=attendance_item,
                        context=self.context
                    )
                    
                    if attendance_serializer.is_valid():
                        attendance_serializer.save(waste=instance)
                    else:
                        errors.append({
                            'index': index,
                            'errors': attendance_serializer.errors
                        })
                
                # If there are any validation errors in new attendances, raise them
                if errors:
                    raise serializers.ValidationError({
                        'attendances': errors
                    })

            return instance

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
