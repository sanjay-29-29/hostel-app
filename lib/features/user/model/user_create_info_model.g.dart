// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_create_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreateInfoModel _$UserCreateInfoModelFromJson(Map<String, dynamic> json) =>
    UserCreateInfoModel(
      hostels: (json['hostels'] as List<dynamic>)
          .map((e) => HostelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserCreateInfoModelToJson(
  UserCreateInfoModel instance,
) => <String, dynamic>{'hostels': instance.hostels, 'roles': instance.roles};
