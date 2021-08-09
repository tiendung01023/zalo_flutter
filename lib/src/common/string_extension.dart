String? enumToString(dynamic e) {
  if (e == null) return null;
  return e.toString().split('.').last;
}

extension StringExtension on String {
  T? toEnum<T>(List<T> list) {
    try {
      final item = list.firstWhere(
        (e) {
          final t = e.toString().split('.').last;
          return t == this;
        },
      );
      return item;
    } catch (_) {}
    return null;
  }
}
