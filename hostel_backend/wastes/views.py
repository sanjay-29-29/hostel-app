import json
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.viewsets import ModelViewSet

from .filters import WasteFilter
from .models import Waste
from .serializers import WasteCreateAndUpdateSerializer, WasteSerializer


class WasteViewSet(ModelViewSet):
    serializer_class = WasteSerializer
    queryset = (
        Waste.objects.all()
        .select_related("created_by", "updated_by", "timing", "kitchen")
        .prefetch_related("attendances")
    )
    filter_backends = [DjangoFilterBackend]
    filterset_class = WasteFilter

    def get_serializer_class(self):
        if (
            self.action == "create"
            or self.action == "update"
            or self.action == "partial_update"
        ):
            return WasteCreateAndUpdateSerializer
        return WasteSerializer

    def create(self, request, *args, **kwargs):
        return super().create(request, *args, **kwargs)

    def update(self, request, *args, **kwargs):
        # if request.data.get("kitchen") is not None:
            # del request.data["kitchen"]
        return super().update(request, *args, **kwargs)

    def perform_create(self, serializer):
        user = self.request.user
        serializer.save(created_by=user, updated_by=user)

    def perform_update(self, serializer):
        serializer.save(updated_by=self.request.user)
