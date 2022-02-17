import '../common/string_extension.dart';
import 'zalo_error_model.dart';

enum ZOLoginType {
  APPLE, // Only ios
  FACEBOOK,
  GOOGLE,
  GUEST,
  UNKNOWN,
  ZALO,
  ZINGME,
}

class ZaloLogin {
  ZaloLogin.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    isSuccess = map['isSuccess'] as bool?;
    error = ZaloError.fromJson(map['error'] as Map<dynamic, dynamic>?);
    data = ZaloLoginData.fromJson(map['data'] as Map<dynamic, dynamic>?);
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
  ZaloLoginData? data;
}

class ZaloLoginData {
  ZaloLoginData.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    oauthCode = map['oauthCode'] as String?;
    codeVerifier = map['codeVerifier'] as String?;
    type = (map['type'] as String?)?.toEnum(ZOLoginType.values);
    userId = map['userId'] as String?;
    displayName = map['displayName'] as String?;
    phoneNumber = map['phoneNumber'] as String?;
    dob = map['dob'] as String?;
    gender = map['gender'] as String?;
    zcert = map['zcert'] as bool?;
    zprotect = map['zprotect'] as bool?;
    isRegister = map['isRegister'] as bool?;
    facebookAccessToken = map['facebookAccessToken'] as String?;
    // facebookAccessTokenExpiredDate= map['facebookAccessTokenExpiredDate'] as String?;
    socialId = map['socialId'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['oauthCode'] = oauthCode;
    map['codeVerifier'] = codeVerifier;
    map['type'] = enumToString(type);
    map['userId'] = userId;
    map['displayName'] = displayName;
    map['phoneNumber'] = phoneNumber;
    map['dob'] = dob;
    map['gender'] = gender;
    map['zcert'] = zcert;
    map['zprotect'] = zprotect;
    map['isRegister'] = isRegister;
    map['facebookAccessToken'] = facebookAccessToken;
    // map['facebookAccessTokenExpiredDate'] = facebookAccessTokenExpiredDate;
    map['socialId'] = socialId;
    return map;
  }

  /// Use for android and ios
  String? oauthCode;

  /// Use for android and ios
  String? codeVerifier;

  /// Use for android and ios
  ZOLoginType? type;

  /// Use for android and ios
  String? userId;

  /// Only use for ios
  String? displayName;

  /// Only use for ios
  String? phoneNumber;

  /// Only use for ios
  String? dob;

  /// Only use for ios
  String? gender;

  /// Only use for ios
  bool? zcert;

  /// Only use for ios
  bool? zprotect;

  /// Use for android and ios
  bool? isRegister;

  /// Use for android and ios
  String? facebookAccessToken;

  /// Use for android and ios
  // String? facebookAccessTokenExpiredDate;

  /// Use for android and ios
  String? socialId;
}
