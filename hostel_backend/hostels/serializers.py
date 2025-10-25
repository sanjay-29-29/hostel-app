from rest_framework import serializers

from hostels.models import Hostel


class HostelDropdownSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hostel
        fields = ["id", "name"]
