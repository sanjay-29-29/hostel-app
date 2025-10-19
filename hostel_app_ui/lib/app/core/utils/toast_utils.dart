// import 'package:toastification/toastification.dart';
// import 'package:flutter/material.dart';

// class ToastUtils {
//   static void _show({
//     required String title,
//     required String message,
//     required Color color,
//     required ToastificationType type,
//     Duration duration = const Duration(seconds: 2),
//   }) {
//     toastification.show(
//       type: type,
//       style: ToastificationStyle.flat,
//       autoCloseDuration: duration,
//       alignment: Alignment.bottomCenter,
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//       description: Text(message, style: const TextStyle(color: Colors.white)),
//     );
//   }
//
//   static void showInfo(String message, {String title = 'Info'}) {
//     _show(title: title, message: message, type: ToastificationType.info);
//   }
//
//   static void showSuccess(String message, {String title = 'Success'}) {
//     _show(title: title, message: message, type: ToastificationType.success);
//   }
//
//   static void showWarning(String message, {String title = 'Warning'}) {
//     _show(title: title, message: message, type: ToastificationType.warning);
//   }
//
//   static void showError(String message, {String title = 'Error'}) {
//     _show(title: title, message: message, type: ToastificationType.error);
//   }
// }
