// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostelModel _$HostelModelFromJson(Map<String, dynamic> json) => HostelModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  studentsCount: (json['students_count'] as num).toInt(),
);

Map<String, dynamic> _$HostelModelToJson(HostelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'students_count': instance.studentsCount,
    };
