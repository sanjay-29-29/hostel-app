from rest_framework.generics import UpdateAPIView
from hostels.models import Hostel
from hostels.serializers import HostelDropdownSerializer


class HostelUpdateView(UpdateAPIView):
    serializer_class = HostelDropdownSerializer
    queryset = Hostel.objects.all()

    def get_queryset(self):
        user = self.request.user
        return self.queryset.filter(
            name__in=[hostel.name for hostel in user.hostels.all()]
        )
