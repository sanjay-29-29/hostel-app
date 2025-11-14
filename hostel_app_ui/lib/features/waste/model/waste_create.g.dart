// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WasteCreateModel _$WasteCreateModelFromJson(Map<String, dynamic> json) =>
    WasteCreateModel(
      coffeWaste: (json['coffe_waste'] as num?)?.toInt(),
      foodCookedWaste: (json['food_cooked_waste'] as num?)?.toInt(),
      studentWaste: (json['student_waste'] as num?)?.toInt(),
      attendances: (json['attendances'] as List<dynamic>)
          .map((e) => AttendanceCreateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      kitchen: (json['kitchen'] as num).toInt(),
      timing: (json['timing'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$WasteCreateModelToJson(WasteCreateModel instance) =>
    <String, dynamic>{
      'date': WasteCreateModel._toJsonDate(instance.date),
      'coffe_waste': instance.coffeWaste,
      'food_cooked_waste': instance.foodCookedWaste,
      'student_waste': instance.studentWaste,
      'kitchen': instance.kitchen,
      'attendances': instance.attendances,
      'timing': instance.timing,
    };

AttendanceCreateModel _$AttendanceCreateModelFromJson(
  Map<String, dynamic> json,
) => AttendanceCreateModel(
  hostelId: (json['hostel_id'] as num).toInt(),
  studentsPresent: (json['students_present'] as num).toInt(),
  studentsAbsent: (json['students_absent'] as num).toInt(),
);

Map<String, dynamic> _$AttendanceCreateModelToJson(
  AttendanceCreateModel instance,
) => <String, dynamic>{
  'hostel_id': instance.hostelId,
  'students_present': instance.studentsPresent,
  'students_absent': instance.studentsAbsent,
};
