import 'package:hostel_app/features/shared/models/waste/waste_model.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'waste_create.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WasteCreateModel {
  final int? coffeWaste;
  final int? foodCookedWaste;
  final int? studentWaste;

  //TODO: hostel_id for warden, when creating
  final int? hostel;
  final List<AttendanceModel>? attendances;

  @JsonKey(toJson: _toJsonDate)
  final DateTime date;
  final int timing;

  const WasteCreateModel({
    this.coffeWaste,
    this.foodCookedWaste,
    this.studentWaste,
    this.hostel,
    this.attendances,
    required this.timing,
    required this.date,
  });

  factory WasteCreateModel.fromJson(Map<String, dynamic> json) =>
      _$WasteCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$WasteCreateModelToJson(this);

  static String _toJsonDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);
}
