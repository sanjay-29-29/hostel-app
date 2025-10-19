import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/storage/secure_storage.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final secureStorage = SecureStorage();

  final dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
});
