from django.contrib import admin

from hostels.models import Hostel

# Register your models here.

@admin.register(Hostel)
class HostelAdmin(admin.ModelAdmin):
    pass
