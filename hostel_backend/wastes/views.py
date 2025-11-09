from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.viewsets import ModelViewSet

from .filters import WasteFilter
from .models import Waste
from .serializers import WasteSerializer


class WasteViewSet(ModelViewSet):
    serializer_class = WasteSerializer
    queryset = Waste.objects.all().select_related(
        "created_by", "updated_by", "timing", "hostel"
    )
    filter_backends = [DjangoFilterBackend]
    filterset_class = WasteFilter

    def create(self, request, *args, **kwargs):
        request.data["hostel"] = request.user.hostel.id
        return super().create(request, *args, **kwargs)

    def perform_create(self, serializer):
        user = self.request.user
        serializer.save(created_by=user, updated_by=user)

    def perform_update(self, serializer):
        serializer.save(updated_by=self.request.user)
