import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/features/login/model/signup_model.dart';
import 'package:hostel_app/features/login/model/token_model.dart';
import 'package:result_dart/result_dart.dart';

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
      return Success(TokenModel.fromJson(response.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        ToastUtil.error('Incorrect username or password');
      } else {
        ToastUtil.error('Something went wrong');
      }
      return Failure(e);
    }
  }

  @override
  Future<Result<int>> signup(SignupModel signupModel) async {
    try {
      final response = await _dioClient.post(
        Endpoints.register,
        data: signupModel.toJson(),
      );
      return Success(response.statusCode!);
    } on DioException catch (e) {
      return Failure(e);
    }
  }
}
