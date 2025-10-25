import django_filters
from django.contrib.auth import get_user_model
from django.db.models.expressions import Q


class UserFilter(django_filters.FilterSet):
    search = django_filters.CharFilter(method="filter_search")

    class Meta:
        model = get_user_model()
        fields = [
            "name",
            "email",
            "role",
        ]

    def filter_search(self, queryset, _name, value):
        return queryset.filter(
            Q(name__icontains=value)
            | Q(email__icontains=value)
            | Q(role__icontains=value)
        )
