extension DataExtension on Object? {
  T? getValue<T>([String key = ""]) {
    if (key.isNotEmpty && this is Map<String, dynamic>) {
      var map = this as Map<String, dynamic>;
      return map[key];
    } else if (this is T) {
      return this as T;
    }
    return null;
  }
}

extension MapExtension on Map<String, dynamic>? {
  T? getValue<T>(String key) {
    return this?[key];
  }
}
