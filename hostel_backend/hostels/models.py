from django.db import models


class Hostel(models.Model):
    name = models.CharField()
    count = models.BigIntegerField()

    def __str__(self):
        return self.name
