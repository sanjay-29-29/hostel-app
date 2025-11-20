import 'package:json_annotation/json_annotation.dart';

part 'timing_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimingModel {
  int id;
  String name;

  TimingModel({required this.id, required this.name});

  factory TimingModel.fromJson(Map<String, dynamic> json) =>
      _$TimingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimingModelToJson(this);
}
