from django.contrib.auth import get_user_model
from django.db import models

from hostels.models import Hostel


class Timing(models.Model):
    name = models.CharField(max_length=30)

    def __str__(self):
        return self.name


class Waste(models.Model):
    coffe_waste = models.IntegerField()
    food_cooked_waste = models.IntegerField()
    student_waste = models.IntegerField()

    students_present = models.IntegerField()

    date = models.DateField()
    hostel = models.ForeignKey(to=Hostel, on_delete=models.CASCADE)
    timing = models.ForeignKey(to=Timing, on_delete=models.CASCADE)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    created_by = models.ForeignKey(
        to=get_user_model(), on_delete=models.CASCADE, related_name="waste_created"
    )
    updated_by = models.ForeignKey(
        to=get_user_model(), on_delete=models.CASCADE, related_name="waste_updated"
    )

    class Meta:
        unique_together = ("hostel", "timing", "date")

    def __str__(self):
        return f"{self.date} {self.hostel.name} {self.timing.name}"
