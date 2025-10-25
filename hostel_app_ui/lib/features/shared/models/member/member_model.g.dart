// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManageMember _$ManageMemberFromJson(Map<String, dynamic> json) => ManageMember(
  name: json['name'] as String,
  role: json['role'] as String,
  hostel: json['hostel'] as String,
  status: json['status'] as String,
  phoneNumber: json['phoneNumber'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$ManageMemberToJson(ManageMember instance) =>
    <String, dynamic>{
      'name': instance.name,
      'role': instance.role,
      'hostel': instance.hostel,
      'status': instance.status,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
    };
