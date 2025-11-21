from django.contrib.auth import get_user_model
from django.db import models

from hostels.models import Hostel


class Timing(models.Model):
    name = models.CharField(max_length=30)

    def __str__(self):
        return f"{self.name}"


class Attendance(models.Model):
    hostel = models.ForeignKey(to=Hostel, on_delete=models.CASCADE)
    students_present = models.IntegerField()
    students_absent = models.IntegerField()

    def __str__(self) -> str:
        return self.hostel.name


class Kitchen(models.Model):
    name = models.CharField(max_length=10)
    hostels = models.ManyToManyField(to=Hostel)

    def __str__(self):
        return f"{self.name}"


class Waste(models.Model):
    date = models.DateField()

    coffe_waste = models.IntegerField(null=True)
    food_cooked_waste = models.IntegerField(null=True)
    student_waste = models.IntegerField(null=True)
    timing = models.ForeignKey(to=Timing, on_delete=models.CASCADE)

    kitchen = models.ForeignKey(to=Kitchen, on_delete=models.CASCADE)
    attendances = models.ManyToManyField(to=Attendance, related_name="attendances")

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    created_by = models.ForeignKey(
        to=get_user_model(), on_delete=models.CASCADE, related_name="waste_created"
    )
    updated_by = models.ForeignKey(
        to=get_user_model(), on_delete=models.CASCADE, related_name="waste_updated"
    )

    class Meta:
        unique_together = ("kitchen", "timing", "date")

    def __str__(self):
        return f"{self.date} {self.timing.name}"
