from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import generics

from .models import Student
from .serializers import StudentSearchSerializer
from .filters import StudentFilter


class StudentSearchView(generics.ListAPIView):
    permission_classes = []
    serializer_class = StudentSearchSerializer
    queryset = Student.objects.all()
    filter_backends = [DjangoFilterBackend]
    filterset_class = StudentFilter
