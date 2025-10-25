from django.db import models


class Hostel(models.Model):
    name = models.CharField(max_length=30)
    count = models.BigIntegerField()

    def __str__(self):
        return self.name
