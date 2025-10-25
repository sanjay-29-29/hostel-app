import 'package:json_annotation/json_annotation.dart';

part 'role_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RoleModel {
  int id;
  String name;

  RoleModel({required this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}
