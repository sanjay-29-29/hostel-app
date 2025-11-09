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

  @JsonKey(toJson: _toJsonDate)
  final DateTime date;
  final int timing;
  final int studentsPresent;

  const WasteCreateModel({
    this.coffeWaste,
    this.foodCookedWaste,
    this.studentWaste,
    this.hostel,
    required this.timing,
    required this.studentsPresent,
    required this.date,
  });

  factory WasteCreateModel.fromJson(Map<String, dynamic> json) =>
      _$WasteCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$WasteCreateModelToJson(this);

  static String _toJsonDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);
}
