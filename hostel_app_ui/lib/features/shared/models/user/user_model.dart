import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  int id;
  String email;
  String name;
  String phoneNumber;
  String role;
  List<HostelModel> hostel;
  String dateJoined;
  bool isActive;
  bool isNew;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.dateJoined,
    required this.role,
    required this.hostel,
    required this.phoneNumber,
    required this.isActive,
    required this.isNew,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
