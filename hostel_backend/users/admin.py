from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin

from users.models import HostelMembership


@admin.register(get_user_model())
class CustomUserAdmin(UserAdmin):
    ordering = ("email",)
    list_display = ("email", "first_name", "last_name", "is_staff")
    search_fields = ("first_name", "last_name", "email")
    fieldsets = (
        (None, {"fields": ("email", "password")}),
        (("Personal info"), {"fields": ("first_name", "last_name", "phone_number")}),
        (
            ("Permissions"),
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                ),
            },
        ),
        (("Important dates"), {"fields": ("last_login", "date_joined")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "email",
                    "first_name",
                    "last_name",
                    "role",
                    "password1",
                    "password2",
                ),
            },
        ),
    )


@admin.register(HostelMembership)
class HostelMembershipAdmin(admin.ModelAdmin):
    pass
