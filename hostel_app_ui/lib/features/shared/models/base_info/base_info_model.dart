import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/kitchen/kitchen_model.dart';
import 'package:hostel_app/features/shared/models/role/role_model.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseInfoModel {
  List<HostelModel> hostels;
  List<KitchenModel> kitchens;
  List<RoleModel> roles;
  List<TimingModel> timings;

  BaseInfoModel({
    required this.kitchens,
    required this.hostels,
    required this.roles,
    required this.timings,
  });

  factory BaseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BaseInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseInfoModelToJson(this);
}
