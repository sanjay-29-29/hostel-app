import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'waste_create.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WasteCreateModel {
  @JsonKey(toJson: _toJsonDate)
  final DateTime date;
  final int? coffeWaste;
  final int? foodCookedWaste;
  final int? studentWaste;
  final int kitchen;
  final List<AttendanceCreateModel> attendances;
  final int timing;

  const WasteCreateModel({
    this.coffeWaste,
    this.foodCookedWaste,
    this.studentWaste,
    required this.attendances,
    required this.kitchen,
    required this.timing,
    required this.date,
  });

  factory WasteCreateModel.fromJson(Map<String, dynamic> json) =>
      _$WasteCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$WasteCreateModelToJson(this);

  static String _toJsonDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceCreateModel {
  int hostelId;
  int studentsPresent;
  int studentsAbsent;

  AttendanceCreateModel({
    required this.hostelId,
    required this.studentsPresent,
    required this.studentsAbsent,
  });

  factory AttendanceCreateModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceCreateModelToJson(this);
}
