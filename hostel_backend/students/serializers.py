from rest_framework import serializers

from students.models import Student


class StudentSearchSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ["name", "email"]
