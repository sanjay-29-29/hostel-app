// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WasteModel _$WasteModelFromJson(Map<String, dynamic> json) => WasteModel(
  id: (json['id'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  timingName: json['timing_name'] as String,
  hostelName: json['hostel_name'] as String,
  createdBy: json['created_by'] as String,
  updatedBy: json['updated_by'] as String,
  attendaces: (json['attendaces'] as List<dynamic>)
      .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  studentWaste: (json['student_waste'] as num?)?.toInt(),
  coffeWaste: (json['coffe_waste'] as num?)?.toInt(),
  foodCookedWaste: (json['food_cooked_waste'] as num?)?.toInt(),
);

Map<String, dynamic> _$WasteModelToJson(WasteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'timing_name': instance.timingName,
      'hostel_name': instance.hostelName,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'coffe_waste': instance.coffeWaste,
      'food_cooked_waste': instance.foodCookedWaste,
      'student_waste': instance.studentWaste,
      'attendaces': instance.attendaces,
    };

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    AttendanceModel(
      hostelName: json['hostel_name'] as String,
      studentsPresent: (json['students_present'] as num).toInt(),
      studentsAbsent: (json['students_absent'] as num).toInt(),
    );

Map<String, dynamic> _$AttendanceModelToJson(AttendanceModel instance) =>
    <String, dynamic>{
      'hostel_name': instance.hostelName,
      'students_present': instance.studentsPresent,
      'students_absent': instance.studentsAbsent,
    };
