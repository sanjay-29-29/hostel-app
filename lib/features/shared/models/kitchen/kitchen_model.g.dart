// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KitchenModel _$KitchenModelFromJson(Map<String, dynamic> json) => KitchenModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  hostels: (json['hostels'] as List<dynamic>)
      .map((e) => HostelModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$KitchenModelToJson(KitchenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hostels': instance.hostels,
    };
