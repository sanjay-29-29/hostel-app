# Install: pip install django-filter
# Add to INSTALLED_APPS: 'django_filters'

import django_filters
from django_filters.rest_framework import DjangoFilterBackend, FilterSet
from .models import Kitchen, Timing, Waste


class WasteFilter(FilterSet):
    date = django_filters.DateFilter(field_name="date", lookup_expr="exact")
    kitchen = django_filters.ModelChoiceFilter(queryset=Kitchen.objects.all())
    timing = django_filters.ModelChoiceFilter(queryset=Timing.objects.all())
    date_range = django_filters.DateFromToRangeFilter(field_name="date")

    class Meta:
        model = Waste
        fields = [
            "date",
            "kitchen",
            "timing",
            "date_range",
        ]
