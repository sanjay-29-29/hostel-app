import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtil {
  /// Success Toast
  static void success(String message, {String title = 'Success'}) {
    toastification.show(
      autoCloseDuration: Duration(seconds: 2),
      type: ToastificationType.success,
      title: Text(title),
      description: Text(message),
    );
  }

  /// Error Toast
  static void error(String message, {String title = 'Error'}) {
    toastification.show(
      autoCloseDuration: Duration(seconds: 2),
      type: ToastificationType.error,
      title: Text(title),
      description: Text(message),
    );
  }

  /// Warning Toast
  static void warning(String message, {String title = 'Warning'}) {
    toastification.show(
      autoCloseDuration: Duration(seconds: 2),
      type: ToastificationType.warning,
      title: Text(title),
      description: Text(message),
    );
  }

  /// Info Toast
  static void info(String message, {String title = 'Info'}) {
    toastification.show(
      autoCloseDuration: Duration(seconds: 2),
      type: ToastificationType.info,
      title: Text(title),
      description: Text(message),
    );
  }
}
