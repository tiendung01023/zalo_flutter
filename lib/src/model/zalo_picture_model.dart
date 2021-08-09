class ZaloPicture {
  ZaloPicture.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    data = ZaloPictureData.fromJson(json['data'] as Map<dynamic, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['data'] = data?.toJson();
    return map;
  }

  ZaloPictureData? data;
}

class ZaloPictureData {
  ZaloPictureData.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return;
    }
    url = json['url'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }

  String? url;
}
