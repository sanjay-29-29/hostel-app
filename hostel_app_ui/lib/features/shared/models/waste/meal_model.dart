import 'package:json_annotation/json_annotation.dart';

part 'meal_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MealModel {
  int id;
  String name;

  MealModel({required this.id, required this.name});

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealModelToJson(this);
}
