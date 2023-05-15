extension DataExtension on dynamic {
  T? getValue<T>([String key = ""]) {
    if (key.isNotEmpty && this is Map<String, dynamic>) {
      return this[key];
    } else if (this is T){
      return this as T;
    }
    return null;
  }
}
