import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/result/result.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';
import 'package:hostel_app/features/user/model/create_user_model.dart';
import 'package:hostel_app/features/user/model/user_create_info_model.dart';

abstract class UserRepository {
  Future<Result<List<UserModel>, Exception>> fetchUsers();
  Future<Result<UserCreateInfoModel, Exception>> fetchUserCreateInfo();
  Future<Result<int, BackendError>> createUser(CreateUserModel model);
  Future<Result<int, BackendError>> updateUser(UpdateUserModel model);

  Future<Result<UserModel, BackendError>> fetchUserByid(int userId);
}

class UserRepositoryImpl implements UserRepository {
  final Dio _dioClient;

  UserRepositoryImpl(this._dioClient);

  Future<Result<List<UserModel>, Exception>> fetchUsers() async {
    try {
      final response = await _dioClient.get(Endpoints.allUsers);
      return Success(
        List<UserModel>.from(
          response.data.map((user) => UserModel.fromJson(user)),
        ),
      );
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<UserCreateInfoModel, Exception>> fetchUserCreateInfo() async {
    try {
      final response = await _dioClient.get(Endpoints.createInfo);
      return Success(UserCreateInfoModel.fromJson(response.data));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int, BackendError>> createUser(CreateUserModel model) async {
    try {
      final response = await _dioClient.post(
        Endpoints.userBase,
        data: model.toJson(),
      );
      return Success(response.statusCode!);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }

  Future<Result<int, BackendError>> updateUser(UpdateUserModel model) async {
    try {
      final response = await _dioClient.patch(
        '${Endpoints.userBase}/${model.id}/',
        data: model.toJson(),
      );
      return Success(response.statusCode!);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }

  Future<Result<UserModel, BackendError>> fetchUserByid(int userId) async {
    try {
      final response = await _dioClient.get('${Endpoints.userBase}/$userId/');
      return Success(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }
}
