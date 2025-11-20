import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kitchen_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class KitchenModel {
  final int id;
  final String name;
  final List<HostelModel> hostels;

  const KitchenModel({
    required this.id,
    required this.name,
    required this.hostels,
  });

  factory KitchenModel.fromJson(Map<String, dynamic> json) =>
      _$KitchenModelFromJson(json);

  Map<String, dynamic> toJson() => _$KitchenModelToJson(this);
}
