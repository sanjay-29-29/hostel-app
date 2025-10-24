import django_filters
from django.db.models.sql.query import Q

from .models import Student


class StudentFilter(django_filters.FilterSet):
    search = django_filters.CharFilter(method="filter_search")

    class Meta:
        model = Student
        fields = ["name", "email"]

    def filter_search(self, queryset, _name, value):
        return queryset.filter(Q(name__icontains=value) | Q(email__icontains=value))
