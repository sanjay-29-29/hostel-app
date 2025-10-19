import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hostel_app/app/core/storage/secure_storage.dart';
import 'package:hostel_app/app/provider/dio_provider.dart';
import 'package:hostel_app/features/login/repository/auth_repository.dart';
import 'package:toastification/toastification.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final String? error;

  const AuthState({required this.status, this.error});

  AuthState copyWith({AuthStatus? status, String? token, String? error}) {
    return AuthState(status: status ?? this.status, error: error);
  }

  factory AuthState.initial() =>
      const AuthState(status: AuthStatus.unauthenticated);
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorage secureStorage = SecureStorage();

  AuthController(this._repository) : super(AuthState.initial());

  Future<bool> login(String username, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final response = await _repository.login(username, password);
      // await _repository.saveToken(token);
      if (response.isSuccess) {
        state = state.copyWith(status: AuthStatus.authenticated);
        secureStorage.saveToken(response.data!.token);
        toastification.show(
          title: Text('Success'),
          type: ToastificationType.success,
          description: RichText(
            text: const TextSpan(text: 'This is a sample toast message. '),
          ),
        );
        return true;
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
    return false;
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.unauthenticated, token: null);
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.watch(dioClientProvider)),
);
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref.watch(authRepositoryProvider));
  },
);
