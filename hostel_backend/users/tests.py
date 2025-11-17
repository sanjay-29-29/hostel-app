from django.test import TestCase
from django.contrib.auth import get_user_model
from django.core import mail
from django.utils import timezone
from rest_framework.test import APIClient
from rest_framework import status
from datetime import timedelta

from users.models import Role, PasswordResetOTP


class PasswordResetOTPTestCase(TestCase):
    def setUp(self):
        """Set up test data"""
        self.client = APIClient()

        # Create a role
        self.role = Role.objects.create(name="Student")

        # Create a test user
        User = get_user_model()
        self.user = User.objects.create_user(
            email="test@example.com",
            password="testpass123",
            name="Test User",
            phone_number="1234567890",
            role=self.role,
        )

    def test_generate_otp_for_existing_user(self):
        """Test OTP generation for an existing user"""
        response = self.client.get(
            "/api/users/forgot-password/", {"email": "test@example.com"}
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("Password reset OTP sent", response.data["detail"])

        # Verify OTP was created in database
        otp_record = PasswordResetOTP.objects.filter(email="test@example.com").last()
        self.assertIsNotNone(otp_record)
        self.assertEqual(len(otp_record.otp), 6)
        self.assertTrue(otp_record.otp.isdigit())

        # Verify email was sent
        self.assertEqual(len(mail.outbox), 1)
        self.assertEqual(mail.outbox[0].subject, "Password Reset OTP")
        self.assertIn(otp_record.otp, mail.outbox[0].body)
        self.assertIn("test@example.com", mail.outbox[0].to)

    def test_otp_for_non_existing_user(self):
        """Test OTP generation for non-existing user returns 404"""
        response = self.client.get(
            "/api/users/forgot-password/", {"email": "nonexistent@example.com"}
        )

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertIn(
            "User with provided email not found", str(response.data["detail"])
        )

        # Verify no email was sent
        self.assertEqual(len(mail.outbox), 0)

    def test_otp_validity(self):
        """Test OTP validity checking"""
        otp_record = PasswordResetOTP.objects.create(
            email="test@example.com", otp="123456"
        )

        # Should be valid immediately after creation
        self.assertTrue(otp_record.is_valid())

        # Mark as used and check validity
        otp_record.is_used = True
        otp_record.save()
        self.assertFalse(otp_record.is_valid())

        # Create expired OTP
        expired_otp = PasswordResetOTP.objects.create(
            email="test@example.com", otp="654321"
        )
        expired_otp.expires_at = timezone.now() - timedelta(minutes=1)
        expired_otp.save()
        self.assertFalse(expired_otp.is_valid())

    def test_otp_expiration_time(self):
        """Test that OTP has correct expiration time"""
        otp_record = PasswordResetOTP.objects.create(
            email="test@example.com", otp="123456"
        )

        # OTP should expire in 10 minutes (with some tolerance)
        expected_expiration = timezone.now() + timedelta(minutes=10)
        time_difference = abs(
            (otp_record.expires_at - expected_expiration).total_seconds()
        )

        # Allow 5 seconds tolerance
        self.assertLess(time_difference, 5)
