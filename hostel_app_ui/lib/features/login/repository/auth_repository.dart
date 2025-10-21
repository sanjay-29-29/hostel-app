import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/result/result.dart';
import 'package:hostel_app/features/login/model/signup_model.dart';
import 'package:hostel_app/features/login/model/token_model.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';

abstract class AuthRepository {
  Future<Result<TokenModel, BackendError>> login(
    String username,
    String password,
  );
  Future<Result<int, Map<String, List<String>>>> signup(
    SignupModel signupModel,
  );
}

class AuthRepositoryImpl extends AuthRepository {
  final Dio _dioClient;

  AuthRepositoryImpl(this._dioClient);

  @override
  Future<Result<TokenModel, BackendError>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _dioClient.post(
        Endpoints.login,
        data: {'username': username, 'password': password},
      );
      return Success(TokenModel.fromJson(response.data));
    } on DioException catch (e) {
      final data = e.response?.data;
      return Failure(BackendError.fromJson(data));
    }
  }

  @override
  Future<Result<int, Map<String, List<String>>>> signup(
    SignupModel signupModel,
  ) async {
    try {
      final response = await _dioClient.post(
        Endpoints.register,
        data: signupModel.toJson(),
      );
      return Success(response.statusCode!);
    } on DioException catch (e) {
      return Failure(e.response?.data);
    }
  }
}
