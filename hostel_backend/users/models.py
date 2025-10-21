from django.contrib.auth import get_user_model
from django.contrib.auth.models import (
    AbstractBaseUser,
    BaseUserManager,
    PermissionsMixin,
)
from django.db import models
from django.db.transaction import on_commit
from django.utils import timezone

from hostels.models import Hostel


class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email field must be set")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        return self.create_user(email, password, **extra_fields)


class CustomUser(AbstractBaseUser, PermissionsMixin):
    class Role(models.TextChoices):
        WARDEN = "WARDEN", "Warden"
        FLOOR_WARDEN = "FLOOR WARDEN", "Floor Warden"
        DEPUTY_WARDEN = "DEPUTY WARDEN", "Deputy Warden"
        CARETAKER = "CARETAKER", "Caretaker"

    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    phone_number = models.CharField(max_length=10)
    role = models.CharField(max_length=20, choices=Role.choices)
    hostel = models.ManyToManyField(
        to=Hostel,
        through="HostelMembership",
        related_name="assigned_users",
    )
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)

    objects = CustomUserManager()

    USERNAME_FIELD = "email"

    def __str__(self):
        return self.email


class HostelMembership(models.Model):
    hostel = models.ForeignKey(to=Hostel, on_delete=models.CASCADE)
    user = models.ForeignKey(to=CustomUser, on_delete=models.CASCADE)
    assigned_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.hostel.name} {self.user.email}"
