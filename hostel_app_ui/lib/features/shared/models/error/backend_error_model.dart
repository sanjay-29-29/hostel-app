class BackendError {
  final Map<String, List<String>> errors;

  BackendError({required this.errors});

  factory BackendError.fromJson(Map<String, dynamic> json) {
    final errors = <String, List<String>>{};

    json.forEach((key, value) {
      if (value is List) {
        errors[key] = List<String>.from(value);
      } else if (value is String) {
        errors[key] = [value];
      }
    });

    return BackendError(errors: errors);
  }

  bool get hasErrors => errors.isNotEmpty;
  String? get nonFieldErrors => errors['non_field_errors']?[0];
  String? get detail => errors['detail']?[0];
  List<String>? getFieldErrors(String fieldName) => errors[fieldName];
}
