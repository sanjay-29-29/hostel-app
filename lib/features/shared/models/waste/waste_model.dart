import 'package:json_annotation/json_annotation.dart';

part 'waste_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WasteModel {
  final int id;

  final DateTime date;
  final String timingName;
  final String kitchenName;

  final String createdBy;
  final String updatedBy;

  final int? coffeWaste;
  final int? foodCookedWaste;
  final int? studentWaste;

  final List<AttendanceModel> attendances;

  const WasteModel({
    required this.id,
    required this.date,
    required this.timingName,
    required this.kitchenName,
    required this.createdBy,
    required this.updatedBy,
    required this.attendances,
    this.studentWaste,
    this.coffeWaste,
    this.foodCookedWaste,
  });

  factory WasteModel.fromJson(Map<String, dynamic> json) =>
      _$WasteModelFromJson(json);

  Map<String, dynamic> toJson() => _$WasteModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceModel {
  final int hostelId;
  final String hostelName;
  final int studentsPresent;
  final int studentsAbsent;

  const AttendanceModel({
    required this.hostelId,
    required this.hostelName,
    required this.studentsPresent,
    required this.studentsAbsent,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WasteModelCSV {
  final DateTime date;
  final String session;
  final double? coffeWaste; 
  final double? foodCookedWaste;
  final double? studentWaste;
  final int presentCount;
  final int absentCount;

  WasteModelCSV({
    required this.date,
    required this.session,
    this.coffeWaste,
    this.foodCookedWaste,
    this.studentWaste,
    required this.presentCount,
    required this.absentCount,
  });

 factory WasteModelCSV.fromJson(Map<String, dynamic> json) =>
      _$WasteModelCSVFromJson(json);

  Map<String, dynamic> toJson() => _$WasteModelCSVToJson(this);
}