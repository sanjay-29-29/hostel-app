from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin

from users.models import HostelMembership, Role, PasswordResetOTP


@admin.register(get_user_model())
class CustomUserAdmin(UserAdmin):
    ordering = ("email",)
    list_display = ("email", "name", "is_staff")
    search_fields = ("first_name", "last_name", "email")
    fieldsets = (
        (
            None,
            {"fields": ("email", "password", "role")},
        ),
        (("Personal info"), {"fields": ("name", "phone_number")}),
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
                    "name",
                    "role",
                    "password1",
                    "password2",
                ),
            },
        ),
    )


@admin.register(Role)
class RoleAdmin(admin.ModelAdmin):
    pass


@admin.register(HostelMembership)
class HostelMembershipAdmin(admin.ModelAdmin):
    pass


@admin.register(PasswordResetOTP)
class PasswordResetOTPAdmin(admin.ModelAdmin):
    list_display = ("email", "otp", "created_at", "expires_at", "is_used", "is_valid")
    list_filter = ("is_used", "created_at")
    search_fields = ("email",)
    readonly_fields = ("created_at",)
