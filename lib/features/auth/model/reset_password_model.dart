import 'package:json_annotation/json_annotation.dart';

part 'reset_password_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResetPassswordModel {
  final String newPassword;
  final String confirmPassword;
  final int otp;
  final String email;

  const ResetPassswordModel({
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
    required this.email,
  });

  factory ResetPassswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPassswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPassswordModelToJson(this);
}
