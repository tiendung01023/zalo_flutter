class ZaloError {
  ZaloError.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    errorCode = map['errorCode'] as int?;
    errorMessage = map['errorMessage'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['errorCode'] = errorCode;
    map['errorMessage'] = errorMessage;
    return map;
  }

  int? errorCode;
  String? errorMessage;
}
