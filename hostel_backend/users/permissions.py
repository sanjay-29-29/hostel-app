from rest_framework import permissions


class IsWarden(permissions.BasePermission):
    def has_permission(self, request, view):
        return (
            request.user
            and request.user.is_authenticated
            and (
                request.user.is_staff or request.user.role == "WARDEN"
                if hasattr(request.user, "role")
                else False
            )
        )
