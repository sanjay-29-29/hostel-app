// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WasteModel _$WasteModelFromJson(Map<String, dynamic> json) => WasteModel(
  id: (json['id'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  studentsPresent: (json['students_present'] as num).toInt(),
  coffeWaste: (json['coffe_waste'] as num).toInt(),
  foodCookedWaste: (json['food_cooked_waste'] as num).toInt(),
  timing: json['timing'] as String,
  hostel: json['hostel'] as String,
  createdBy: json['created_by'] as String,
  updatedBy: json['updated_by'] as String,
);

Map<String, dynamic> _$WasteModelToJson(WasteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'students_present': instance.studentsPresent,
      'coffe_waste': instance.coffeWaste,
      'food_cooked_waste': instance.foodCookedWaste,
      'timing': instance.timing,
      'hostel': instance.hostel,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
    };
