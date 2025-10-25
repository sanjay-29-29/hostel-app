// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserModel _$CreateUserModelFromJson(Map<String, dynamic> json) =>
    CreateUserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      password: json['password'] as String,
      role: (json['role'] as num).toInt(),
      hostels: (json['hostels'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$CreateUserModelToJson(CreateUserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'password': instance.password,
      'role': instance.role,
      'hostels': instance.hostels,
    };
