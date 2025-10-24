from django.db import models

from hostels.models import Hostel


class Student(models.Model):
    name = models.CharField()
    email = models.EmailField()
    hostel = models.ForeignKey(Hostel, on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return self.name
