import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/role/role_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_create_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserCreateInfoModel {
  List<HostelModel> hostels;
  List<RoleModel> roles;

  UserCreateInfoModel({required this.hostels, required this.roles});

  factory UserCreateInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserCreateInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreateInfoModelToJson(this);
}
