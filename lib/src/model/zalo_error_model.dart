class ZaloError {
  int? errorCode;
  String? errorMessage;

  ZaloError.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) return;
    errorCode = map['errorCode'] as int?;
    errorMessage = map['errorMessage'] as String?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['errorMessage'] = errorMessage;
    return data;
  }
}
