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
      hostel: (json['hostel'] as num?)?.toInt(),
      timing: (json['timing'] as num).toInt(),
      studentsPresent: (json['students_present'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$WasteCreateModelToJson(WasteCreateModel instance) =>
    <String, dynamic>{
      'coffe_waste': instance.coffeWaste,
      'food_cooked_waste': instance.foodCookedWaste,
      'student_waste': instance.studentWaste,
      'hostel': instance.hostel,
      'date': WasteCreateModel._toJsonDate(instance.date),
      'timing': instance.timing,
      'students_present': instance.studentsPresent,
    };
