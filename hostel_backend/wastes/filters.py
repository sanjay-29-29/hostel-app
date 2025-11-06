# Install: pip install django-filter
# Add to INSTALLED_APPS: 'django_filters'

import django_filters
from django_filters.rest_framework import DjangoFilterBackend, FilterSet
from hostels.models import Hostel
from .models import Timing, Waste


class WasteFilter(FilterSet):
    date = django_filters.DateFilter(field_name="date", lookup_expr="exact")
    hostel = django_filters.ModelChoiceFilter(queryset=Hostel.objects.all())
    timing = django_filters.ModelChoiceFilter(queryset=Timing.objects.all())

    class Meta:
        model = Waste
        fields = ["date", "hostel", "timing"]
