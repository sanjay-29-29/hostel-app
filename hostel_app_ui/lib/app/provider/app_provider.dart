import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hostel_app/app/provider/dio_provider.dart';
import 'package:hostel_app/features/auth/notifier/auth_notifier.dart';
import 'package:hostel_app/features/auth/repository/auth_repository.dart';
import 'package:hostel_app/features/user/notifier/add_user_notifier.dart';
import 'package:hostel_app/features/user/notifier/manage_user_notifier.dart';
import 'package:hostel_app/features/user/repository/user_repository.dart';
import 'package:hostel_app/features/waste/notifier/waste_manage_notifier.dart';
import 'package:hostel_app/features/waste/repository/waste_manage_repository.dart';

// Auth Providers
final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.watch(dioClientProvider)),
);
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// User Providers
final addUserNotifierProvider = NotifierProvider<AddUserNotifier, AddUserState>(
  AddUserNotifier.new,
);

final userRepositoryProvider = Provider(
  (ref) => UserRepositoryImpl(ref.watch(dioClientProvider)),
);

final manageUserNotifierProvider =
    StateNotifierProvider<ManageUserNotifier, ManageUserState>((ref) {
      return ManageUserNotifier(ref.watch(userRepositoryProvider));
    });


// Waste Management Providers

final wasteManagementRepositoryProvider = Provider(
  (ref) => WasteManageRepositoryImpl(ref.watch(dioClientProvider)),
);

final wasteManageNotifierProvider =
    StateNotifierProvider<WasteManageNotifier, WasteManageState>((ref) {
      return WasteManageNotifier(ref.watch(wasteManagementRepositoryProvider));
    });
