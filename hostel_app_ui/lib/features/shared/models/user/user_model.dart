import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  String email;
  String name;
  String phoneNumber;
  String role;
  String dateJoined;
  bool isActive;
  bool isNew;

  UserModel({
    required this.name,
    required this.email,
    required this.dateJoined,
    required this.role,
    required this.phoneNumber,
    required this.isActive,
    required this.isNew,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
