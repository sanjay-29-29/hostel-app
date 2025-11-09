import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final publicEndpoints = {
      'login',
    };

    final requiresAuth =
        !publicEndpoints.any((endpoint) => options.path.contains(endpoint));

    if (requiresAuth) {
      final token = await secureStorage.getKey('token');
      if (token != null) {
        options.headers['Authorization'] = 'Token $token';
      }
    }

    handler.next(options);
  }
}

final dioClientProvider = Provider<Dio>((ref) {
  final secureStorage = SecureStorage();

  final dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(AuthInterceptor(secureStorage));

  return dio;
});

