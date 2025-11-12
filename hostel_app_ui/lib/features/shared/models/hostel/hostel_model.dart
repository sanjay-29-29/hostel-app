import 'package:json_annotation/json_annotation.dart';

part 'hostel_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HostelModel {
  int id;
  String name;
  int studentsCount;

  HostelModel({required this.id, required this.name, required this.studentsCount});

  factory HostelModel.fromJson(Map<String, dynamic> json) =>
      _$HostelModelFromJson(json);

  Map<String, dynamic> toJson() => _$HostelModelToJson(this);
}
