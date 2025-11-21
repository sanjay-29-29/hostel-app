from django.contrib import admin
from .models import Attendance, Kitchen, Waste, Timing


@admin.register(Waste)
class WasteAdmin(admin.ModelAdmin):
    pass


@admin.register(Timing)
class TimingAdmin(admin.ModelAdmin):
    pass


@admin.register(Attendance)
class AttendanceAdmin(admin.ModelAdmin):
    pass


@admin.register(Kitchen)
class KitchenAdmin(admin.ModelAdmin):
    pass
