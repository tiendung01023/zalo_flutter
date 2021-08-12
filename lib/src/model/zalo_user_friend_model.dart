import 'package:zalo_flutter/src/model/zalo_picture_model.dart';

import 'zalo_error_model.dart';

class ZaloUserFriend {
  ZaloUserFriend.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    isSuccess = json['isSuccess'] as bool?;
    error = ZaloError.fromJson(json['error'] as Map<dynamic, dynamic>?);
    data = ZaloUserFriendData.fromJson(json['data'] as Map<dynamic, dynamic>?);
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
  ZaloUserFriendData? data;
}

class ZaloUserFriendData {
  ZaloUserFriendData.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    error = json['error'] as int?;
    errorName = json['error_name'] as String?;
    errorReason = json['error_reason'] as String?;
    errorDescription = json['error_description'] as String?;
    message = json['message'] as String?;
    final List<dynamic>? dataList = json['data'] as List<dynamic>?;
    if (dataList != null) {
      data = <ZaloUserFriendData2>[];
      for (final dynamic v in dataList) {
        final Map<dynamic, dynamic>? rs = v as Map<dynamic, dynamic>?;
        if (rs != null) {
          data!.add(ZaloUserFriendData2.fromJson(rs));
        }
      }
    }
    paging = json['paging'] != null
        ? Paging.fromJson(json['paging'] as Map<dynamic, dynamic>?)
        : null;
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'] as Map<dynamic, dynamic>?)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['error'] = error;
    map['error_name'] = errorName;
    map['error_reason'] = errorReason;
    map['error_description'] = errorDescription;
    map['message'] = message;
    map['data'] = data?.map((ZaloUserFriendData2 v) => v.toJson()).toList();
    map['paging'] = paging?.toJson();
    map['summary'] = summary?.toJson();
    return map;
  }

  int? error;
  String? errorName;
  String? errorReason;
  String? errorDescription;
  String? message;
  List<ZaloUserFriendData2>? data;
  Paging? paging;
  Summary? summary;
}

class ZaloUserFriendData2 {
  ZaloUserFriendData2.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    gender = json['gender'] as String?;
    id = json['id'] as String?;
    picture = json['picture'] != null
        ? ZaloPicture.fromJson(json['picture'] as Map<dynamic, dynamic>?)
        : null;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['gender'] = gender;
    map['id'] = id;
    if (picture != null) {
      map['picture'] = picture?.toJson();
    }
    map['name'] = name;
    return map;
  }

  String? gender;
  String? id;
  ZaloPicture? picture;
  String? name;
}

class Paging {
  Paging.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    next = json['next'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['next'] = next;
    return map;
  }

  String? next;
}

class Summary {
  Summary.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    totalCount = json['total_count'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['total_count'] = totalCount;
    return map;
  }

  int? totalCount;
}
