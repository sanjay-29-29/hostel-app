Map<String, List<String>> parseError(dynamic data) {
  if (data is Map<String, dynamic>) {
    final converted = data.map((key, value) {
      return MapEntry(key, List<String>.from(value));
    });
    return converted;
  }
  return {
    'non_field_errors': ['Unknown error occurred'],
  };
}
