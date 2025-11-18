// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPassswordModel _$ResetPassswordModelFromJson(Map<String, dynamic> json) =>
    ResetPassswordModel(
      otp: (json['otp'] as num).toInt(),
      newPassword: json['new_password'] as String,
      confirmPassword: json['confirm_password'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$ResetPassswordModelToJson(
  ResetPassswordModel instance,
) => <String, dynamic>{
  'new_password': instance.newPassword,
  'confirm_password': instance.confirmPassword,
  'otp': instance.otp,
  'email': instance.email,
};
