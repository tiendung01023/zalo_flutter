import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/// * Đăng nhập và lấy thông tin của user
/// * Login and get user profile
class ZaloFlutter {
  ZaloFlutter._();
  static const MethodChannel channel = MethodChannel('zalo_flutter');

  /// * Lấy HashKey của Android để đăng ký trong dashboard Zalo
  /// * Get HashKey Android for register app in dashboard Zalo
  /// * Dashboard: https://developers.zalo.me/app/{your_app_id}/login
  static Future<String?> getHashKeyAndroid() async {
    if (Platform.isAndroid) {
      final String? rs = await channel.invokeMethod<String?>('getHashKey');
      return rs;
    }
    return null;
  }

  /// * Lấy CodeVerifier cho việc xác thực PCKE
  /// * Get CodeVerifier for PCKE authencation
  /// * More info: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-nhap-post-6006
  static String getCodeVerifier() {
    const int length = 43;
    final Random random = Random.secure();
    final String verifier = base64UrlEncode(List<int>.generate(length, (_) => random.nextInt(256))).split('=')[0];
    return verifier;
  }

  /// * Lấy CodeChallenge cho việc xác thực PCKE
  /// * Get CodeChallenge for PCKE authencation
  /// * More info: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-nhap-post-6006
  static String getCodeChallenge(String codeVerifier) {
    final String rs = base64UrlEncode(sha256.convert(ascii.encode(codeVerifier)).bytes).split('=')[0];
    return rs;
  }

  /// * Đăng xuất - SDK xóa oauth code trong cache
  /// * Logout - SDK clear oauth code in cache
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/login/dang-xuat-post-429
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-xuat-post-5728
  static Future<void> logout() async {
    await channel.invokeMethod<void>('logout');
  }

  /// * Xác minh lại refresh token
  /// * Check validate refresh token
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/login/xac-minh-lai-oauth-code-post-427
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/xac-minh-lai-refreshtoken-post-5730
  static Future<bool> validateRefreshToken({
    required String refreshToken,
    List<Object> externalInfo = const <Object>[],
  }) async {
    final bool? rs = await channel.invokeMethod<bool?>(
      'validateRefreshToken',
      <String, dynamic>{
        'refreshToken': refreshToken,
        'extInfo': externalInfo,
      },
    );
    return rs == true;
  }

  /// * Đăng nhập
  /// * Authenticate (with app or webview)
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/login/dang-nhap-bang-zalo-post-250
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-nhap-post-6006
  static Future<Map<dynamic, dynamic>?> login({
    required String codeVerifier,
    required String codeChallenge,
    required String? refreshToken,
    Map<String, dynamic> externalInfo = const <String, dynamic>{},
  }) async {
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'login',
      <String, dynamic>{
        'codeVerifier': codeVerifier,
        'codeChallenge': codeChallenge,
        'extInfo': externalInfo,
        'refreshToken': refreshToken,
      },
    );
    return rs;
  }

  /// * Lấy thông tin người dùng
  /// * Get Zalo user profile
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-thong-tin-nguoi-dung-post-435
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-thong-tin-profile-post-5736
  /// * More info Web: https://developers.zalo.me/docs/api/open-api/tai-lieu/thong-tin-nguoi-dung-post-28
  static Future<Map<dynamic, dynamic>?> getUserProfile({
    required String accessToken,
  }) async {
    // final http.Response response = await http.get(
    //   Uri.parse('https://graph.zalo.me/v2.0/me?fields=id,name,picture,gender,birthday'),
    //   headers: <String, String>{
    //     'access_token': accessToken,
    //   }
    // );
    // if (response.statusCode == 200) {
    //   return response.body;
    // } else {
    //   return '';
    // }
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'getUserProfile',
      <String, dynamic>{
        'accessToken': accessToken,
      },
    );
    return rs;
  }
}

/// * Sử dụng cho OA (đang nghiên cứu)
/// * Use for OA (studying)
class ZaloOAFlutter {
  ZaloOAFlutter._();
  static const MethodChannel channel = MethodChannel('zalo_flutter');

  /// * Lấy danh sách bạn bè (đã sử dụng ứng dụng)
  /// * Get Zalo user friend list (used app)
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-danh-sach-ban-be-post-437
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-danh-sach-ban-be-zalo-post-5813
  static Future<Map<dynamic, dynamic>?> getUserFriendList({
    required String accessToken,
    required int atOffset,
    required int count,
  }) async {
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'getUserFriendList',
      <String, dynamic>{
        'accessToken': accessToken,
        'atOffset': atOffset,
        'count': count,
      },
    );
    return rs;
  }

  /// * Lấy danh sách bạn bè (chưa sử dụng ứng dụng)
  /// * Get Zalo user friend list (not used app)
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-danh-sach-ban-be-post-437
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-danh-sach-ban-be-zalo-post-5813
  static Future<Map<dynamic, dynamic>?> getUserInvitableFriendList({
    required String accessToken,
    required int atOffset,
    required int count,
  }) async {
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'getUserInvitableFriendList',
      <String, dynamic>{
        'accessToken': accessToken,
        'atOffset': atOffset,
        'count': count,
      },
    );
    return rs;
  }

  /// * Gửi tin nhắn tới bạn bè
  /// * Send message to a friend
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/gui-tin-nhan-toi-ban-be-post-1205
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/gui-tin-nhan-cho-ban-be-post-5825
  static Future<Map<dynamic, dynamic>?> sendMessage({
    required String accessToken,
    required String to,
    required String message,
    String? link,
  }) async {
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'sendMessage',
      <String, dynamic>{
        'accessToken': accessToken,
        'to': to,
        'message': message,
        'link': link,
      },
    );
    return rs;
  }

  /// * Đăng bài viết
  /// * Post feed
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/dang-bai-viet-post-1212
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/dang-bai-viet-post-1248
  static Future<Map<dynamic, dynamic>?> postFeed({
    required String accessToken,
    required String message,
    String? link,
  }) async {
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'postFeed',
      <String, dynamic>{
        'accessToken': accessToken,
        'message': message,
        'link': link,
      },
    );
    return rs;
  }

  /// * Mời sử dụng ứng dụng
  /// * Send app request
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/moi-su-dung-ung-dung-post-1218
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/moi-su-dung-ung-dung-post-1251
  static Future<Map<dynamic, dynamic>?> sendAppRequest({
    required String accessToken,
    required List<String> to,
    required String message,
  }) async {
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'sendAppRequest',
      <String, dynamic>{
        'accessToken': accessToken,
        'to': to,
        'message': message,
      },
    );
    return rs;
  }
}