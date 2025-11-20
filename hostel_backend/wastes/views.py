from firebase_admin.messaging import Message, Notification
from fcm_django.models import FCMDevice
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status
from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response

from .filters import WasteFilter
from .models import Kitchen, Waste
from .serializers import WasteCreateAndUpdateSerializer, WasteSerializer


class CustomNotification:
    def __init__(self, title, message):
        self.title = title
        self.message = message


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
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        instance = self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)

        self.send_notifications(
            serializer.data["kitchen"],
            CustomNotification(
                "Hostel App",
                f"{self.request.user.name} added {instance.timing.name} for {instance.date}",
            ),
        )

        return Response(
            serializer.data,
            status=status.HTTP_201_CREATED,
            headers=headers,
        )

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop("partial", False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        self.send_notifications(
            instance.kitchen.id,
            CustomNotification(
                "Hostel App",
                f"{self.request.user.name} updated {instance.timing.name} for {instance.date}",
            ),
        )
        if getattr(instance, "_prefetched_objects_cache", None):
            # If 'prefetch_related' has been applied to a queryset, we need to
            # forcibly invalidate the prefetch cache on the instance.
            instance._prefetched_objects_cache = {}

        return Response(serializer.data)

    def perform_create(self, serializer):
        user = self.request.user
        return serializer.save(created_by=user, updated_by=user)

    def perform_update(self, serializer):
        serializer.save(updated_by=self.request.user)

    def send_notifications(self, kitchen_id, notification: CustomNotification):
        kitchen = Kitchen.objects.prefetch_related("hostels").get(id=kitchen_id)
        devices = FCMDevice.objects.filter(
            user__hostels__in=[hostel.id for hostel in kitchen.hostels.all()]
        )
        for device in devices:
            device.send_message(
                Message(
                    notification=Notification(
                        title=notification.title, body=notification.message
                    ),
                )
            )
