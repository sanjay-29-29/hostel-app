from django.contrib.auth import get_user_model
from django.core import validators
from django.core.validators import MinLengthValidator
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
    def get(self, *args, **kwargs):
        return (
            super()
            .select_related("role")
            .prefetch_related("hostel")
            .get(*args, **kwargs)
        )

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


class Role(models.Model):
    name = models.CharField(max_length=30)

    def __str__(self):
        return self.name


class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    name = models.CharField(
        max_length=50,
        validators=[
            MinLengthValidator(4, "The field must contain at least 4 characters.")
        ],
    )
    phone_number = models.CharField(
        max_length=10,
        validators=[
            MinLengthValidator(10, "The field must contain at least 10 characters.")
        ],
    )
    role = models.ForeignKey(to=Role, on_delete=models.CASCADE)
    hostel = models.ManyToManyField(
        to=Hostel,
        through="HostelMembership",
        related_name="assigned_users",
    )
    is_new = models.BooleanField(default=True)
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
