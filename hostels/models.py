from django.db import models


class Hostel(models.Model):
    name = models.CharField(max_length=30)
    students_count = models.IntegerField()

    def __str__(self):
        return f"{self.name}"
