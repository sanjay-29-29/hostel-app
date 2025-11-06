from django.contrib import admin
from .models import Waste, Timing


@admin.register(Waste)
class WasteAdmin(admin.ModelAdmin):
    pass

@admin.register(Timing)
class TimingAdmin(admin.ModelAdmin):
    pass
