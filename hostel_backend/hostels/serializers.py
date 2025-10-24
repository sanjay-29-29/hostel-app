from rest_framework import serializers

from hostels.models import Hostel


class GetHostelDropdownDetailsSerializer(serializers.ModelSerializer):

    class Meta:
        model = Hostel
        fields = ["id", "name"]

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data["label"] = data.pop("name")
        data["value"] = data.pop("id")
        return data
