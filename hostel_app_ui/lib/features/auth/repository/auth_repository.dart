import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/result/result.dart';
import 'package:hostel_app/features/auth/model/signup_model.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

abstract class AuthRepository {
  Future<Result<(UserModel, String), BackendError>> login(
    String username,
    String password,
  );
  Future<Result<int, BackendError>> signup(SignupModel signupModel);

  Future<Result<void, BackendError>> isUserExistRepo(String username);
}

class AuthRepositoryImpl extends AuthRepository {
  final Dio _dioClient;

  AuthRepositoryImpl(this._dioClient);

  @override
  Future<Result<(UserModel, String), BackendError>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _dioClient.post(
        Endpoints.login,
        data: {'username': username, 'password': password},
      );
      return Success((
        UserModel.fromJson(response.data),
        response.data['token'],
      ));
    } on DioException catch (e) {
      final data = e.response?.data;
      return Failure(BackendError.fromJson(data));
    }
  }

  @override
  Future<Result<int, BackendError>> signup(SignupModel signupModel) async {
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

  @override
  Future<Result<void, BackendError>> isUserExistRepo(String username) async {
    try {
      final response = await _dioClient.post(
        Endpoints.isUserExist,
        data: {'username': username},
      );
      return Success(response.statusCode!);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }
}
