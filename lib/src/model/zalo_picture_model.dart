class ZaloPicture {
  ZaloPictureData? data;

  ZaloPicture.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return;
    data = ZaloPictureData.fromJson(json['data'] as Map<dynamic, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data?.toJson();
    return map;
  }
}

class ZaloPictureData {
  String? url;

  ZaloPictureData.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return;
    url = json['url'] as String?;
  }
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }
}
