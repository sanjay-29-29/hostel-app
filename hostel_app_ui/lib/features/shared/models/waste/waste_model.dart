import 'package:json_annotation/json_annotation.dart';

part 'waste_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WasteModel {
  int id;
  DateTime date;
  int studentsPresent;
  int coffeWaste;
  int foodCookedWaste;
  String timing;
  String hostel;
  String createdBy;
  String updatedBy;

  WasteModel({
    required this.id,
    required this.date,
    required this.studentsPresent,
    required this.coffeWaste,
    required this.foodCookedWaste,
    required this.timing,
    required this.hostel,
    required this.createdBy,
    required this.updatedBy,
  });

  factory WasteModel.fromJson(Map<String, dynamic> json) =>
      _$WasteModelFromJson(json);

  Map<String, dynamic> toJson() => _$WasteModelToJson(this);
}
