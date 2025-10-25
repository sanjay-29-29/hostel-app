import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/result/result.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';

abstract class UserRepository {
  Future<Result<List<UserModel>, Exception>> fetchUsers();
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
}
