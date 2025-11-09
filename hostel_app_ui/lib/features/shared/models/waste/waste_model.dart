import 'package:json_annotation/json_annotation.dart';

part 'waste_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WasteModel {
  int id;

  DateTime date;
  int studentsPresent;
  String timingName;
  String hostelName;

  String createdBy;
  String updatedBy;

  int? coffeWaste;
  int? foodCookedWaste;
  int? studentWaste;

  WasteModel({
    required this.id,
    required this.date,
    required this.studentsPresent,
    required this.timingName,
    required this.hostelName,
    required this.createdBy,
    required this.updatedBy,
    this.studentWaste,
    this.coffeWaste,
    this.foodCookedWaste,
  });

  factory WasteModel.fromJson(Map<String, dynamic> json) =>
      _$WasteModelFromJson(json);

  Map<String, dynamic> toJson() => _$WasteModelToJson(this);
}
