// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseInfoModel _$BaseInfoModelFromJson(Map<String, dynamic> json) =>
    BaseInfoModel(
      hostels: (json['hostels'] as List<dynamic>)
          .map((e) => HostelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      timings: (json['timings'] as List<dynamic>)
          .map((e) => TimingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BaseInfoModelToJson(BaseInfoModel instance) =>
    <String, dynamic>{
      'hostels': instance.hostels,
      'roles': instance.roles,
      'timings': instance.timings,
    };
