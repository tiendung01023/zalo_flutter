import 'zalo_error_model.dart';
import 'zalo_picture_model.dart';

class ZaloProfile {
  ZaloProfile.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    isSuccess = map['isSuccess'] as bool?;
    error = ZaloError.fromJson(map['error'] as Map<dynamic, dynamic>?);
    data = ZaloProfileData.fromJson(map['data'] as Map<dynamic, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['isSuccess'] = isSuccess;
    map['error'] = error?.toJson();
    map['data'] = data?.toJson();
    return map;
  }

  bool? isSuccess;
  ZaloError? error;
  ZaloProfileData? data;
}

class ZaloProfileData {
  ZaloProfileData.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    error = map['error'] as int?;
    errorName = map['error_name'] as String?;
    errorReason = map['error_reason'] as String?;
    errorDescription = map['error_description'] as String?;
    message = map['message'] as String?;

    id = map['id'] as String?;
    name = map['name'] as String?;
    gender = map['gender'] as String?;
    birthday = map['birthday'] as String?;
    picture = ZaloPicture.fromJson(map['picture'] as Map<dynamic, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['error'] = error;
    map['error_name'] = errorName;
    map['error_reason'] = errorReason;
    map['error_description'] = errorDescription;
    map['message'] = message;

    map['id'] = id;
    map['name'] = name;
    map['gender'] = gender;
    map['birthday'] = birthday;
    map['picture'] = picture?.toJson();
    return map;
  }

  int? error;
  String? errorName;
  String? errorReason;
  String? errorDescription;
  String? message;

  String? id;
  String? name;
  String? gender;
  String? birthday;
  ZaloPicture? picture;
}
