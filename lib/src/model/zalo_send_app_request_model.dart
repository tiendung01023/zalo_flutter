import 'zalo_error_model.dart';

class ZaloSendAppRequest {
  ZaloSendAppRequest.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    isSuccess = json['isSuccess'] as bool?;
    error = ZaloError.fromJson(json['error'] as Map<dynamic, dynamic>?);
    data =
        ZaloSendAppRequestData.fromJson(json['data'] as Map<dynamic, dynamic>?);
  }

  bool? isSuccess;
  ZaloError? error;
  ZaloSendAppRequestData? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['isSuccess'] = isSuccess;
    map['error'] = error?.toJson();
    map['data'] = data?.toJson();
    return map;
  }
}

class ZaloSendAppRequestData {
  ZaloSendAppRequestData.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    error = json['error'] as int?;
    errorName = json['error_name'] as String?;
    errorReason = json['error_reason'] as String?;
    errorDescription = json['error_description'] as String?;
    message = json['message'] as String?;
    final List<dynamic>? toList = json['to'] as List<dynamic>?;
    if (toList != null) {
      to = <String>[];
      for (final dynamic v in toList) {
        final String? rs = v as String?;
        if (rs != null) {
          to!.add(rs);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['error'] = error;
    map['error_name'] = errorName;
    map['error_reason'] = errorReason;
    map['error_description'] = errorDescription;
    map['message'] = message;
    map['to'] = to;
    return map;
  }

  int? error;
  String? errorName;
  String? errorReason;
  String? errorDescription;
  String? message;
  List<String>? to;
}
