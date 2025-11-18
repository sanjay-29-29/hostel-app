import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/result/result.dart';
import 'package:hostel_app/features/auth/model/reset_password_model.dart';
import 'package:hostel_app/features/auth/model/signup_model.dart';
import 'package:hostel_app/features/shared/models/base_info/base_info_model.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

abstract class AuthRepository {
  Future<Result<(UserModel, String), BackendError>> login(
    String username,
    String password,
  );
  Future<Result<int, BackendError>> signup(SignupModel signupModel);
  Future<Result<BaseInfoModel, BackendError>> fetchBaseInfo();

  Future<Result<void, BackendError>> requestOTP(String username);
  Future<Result<bool, BackendError>> verifyOTP(String email, int OTP);
  Future<Result<bool, BackendError>> changePassword(
    ResetPassswordModel resetPassword,
  );
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
      print(response.data);
      return Success(
        (
          UserModel.fromJson(response.data),
          response.data['token'],
        ),
      );
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
  Future<Result<BaseInfoModel, BackendError>> fetchBaseInfo() async {
    try {
      final response = await _dioClient.get(Endpoints.createInfo);
      print(response.statusCode);
      return Success(BaseInfoModel.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }

  @override
  Future<Result<void, BackendError>> requestOTP(String email) async {
    try {
      final response = await _dioClient.get(
        Endpoints.forgotPassword,
        queryParameters: {'email': email},
      );
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }

  Future<Result<bool, BackendError>> verifyOTP(String email, int OTP) async {
    try {
      await _dioClient.post(
        Endpoints.verifyOTP,
        data: {'email': email, 'otp': OTP},
      );
      return Success(true);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }

  Future<Result<bool, BackendError>> changePassword(
    ResetPassswordModel resetPassword,
  ) async {
    try {
      await _dioClient.post(
        Endpoints.forgotPassword,
        data: resetPassword.toJson(),
      );
      return Success(true);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }
}
