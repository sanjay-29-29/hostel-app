import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class ManageMember {
  final String name;
  final String role;
  final String hostel;
  final String status;
  final String phoneNumber;
  final String email;

  ManageMember({
    required this.name,
    required this.role,
    required this.hostel,
    required this.status,
    required this.phoneNumber,
    required this.email,
  });

  factory ManageMember.fromJson(Map<String, dynamic> json) =>
      _$ManageMemberFromJson(json);

  Map<String, dynamic> toJson() => _$ManageMemberToJson(this);

  /// ✅ Proper `copyWith` implementation
  ManageMember copyWith({
    String? name,
    String? role,
    String? hostel,
    String? status,
    String? phoneNumber,
    String? email,
  }) {
    return ManageMember(
      name: name ?? this.name,
      role: role ?? this.role,
      hostel: hostel ?? this.hostel,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }
}
