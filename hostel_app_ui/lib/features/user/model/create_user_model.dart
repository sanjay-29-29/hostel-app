import 'package:json_annotation/json_annotation.dart';

part 'create_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateUserModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final int role;
  final int hostel;

  CreateUserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.hostel,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserModelToJson(this);
}
