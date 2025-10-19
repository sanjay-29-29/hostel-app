import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/features/login/model/signup_model.dart';
import 'package:hostel_app/features/login/model/token_model.dart';
import 'package:hostel_app/features/shared/model/result_model.dart';

abstract class AuthRepository {
  Future<Result<TokenModel>> login(String username, String password);
  Future<Result<int>> signup(SignupModel signupModel);
}

class AuthRepositoryImpl extends AuthRepository {
  final Dio _dioClient;

  AuthRepositoryImpl(this._dioClient);

  @override
  Future<Result<TokenModel>> login(String username, String password) async {
    try {
      final response = await _dioClient.post(
        Endpoints.login,
        data: {'username': username, 'password': password},
      );
      return Result.success(TokenModel.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Error');
    }
  }

  @override
  Future<Result<int>> signup(SignupModel signupModel) async {
    try {
      final response = await _dioClient.post(
        Endpoints.register,
        data: signupModel.toJson(),
      );
      return Result.success(response.statusCode!);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Error');
    }
  }
}
