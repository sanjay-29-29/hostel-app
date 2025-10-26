// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  dateJoined: json['date_joined'] as String,
  role: json['role'] as String,
  hostel: (json['hostel'] as List<dynamic>)
      .map((e) => HostelModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  phoneNumber: json['phone_number'] as String,
  isActive: json['is_active'] as bool,
  isNew: json['is_new'] as bool,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'phone_number': instance.phoneNumber,
  'role': instance.role,
  'hostel': instance.hostel,
  'date_joined': instance.dateJoined,
  'is_active': instance.isActive,
  'is_new': instance.isNew,
};
