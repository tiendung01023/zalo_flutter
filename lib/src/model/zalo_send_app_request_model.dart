import 'zalo_error_model.dart';

class ZaloSendAppRequest {
  bool? isSuccess;
  ZaloError? error;
  ZaloSendAppRequestData? data;

  ZaloSendAppRequest.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return;
    isSuccess = json['isSuccess'] as bool?;
    error = ZaloError.fromJson(json['error'] as Map<dynamic, dynamic>?);
    data =
        ZaloSendAppRequestData.fromJson(json['data'] as Map<dynamic, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = isSuccess;
    map['error'] = error?.toJson();
    map['data'] = data?.toJson();
    return map;
  }
}

class ZaloSendAppRequestData {
  int? error;
  String? errorName;
  String? errorReason;
  String? errorDescription;
  String? message;
  List<String>? to;

  ZaloSendAppRequestData.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return;
    error = json['error'] as int?;
    errorName = json['error_name'] as String?;
    errorReason = json['error_reason'] as String?;
    errorDescription = json['error_description'] as String?;
    message = json['message'] as String?;
    if (json['to'] != null) {
      to = <String>[];
      json['to'].forEach((v) {
        final rs = v as String?;
        if (rs != null) to?.add(rs);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['error_name'] = errorName;
    map['error_reason'] = errorReason;
    map['error_description'] = errorDescription;
    map['message'] = message;
    map['to'] = to;
    return map;
  }
}
