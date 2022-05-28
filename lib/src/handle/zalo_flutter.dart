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

  static Duration _timeout = const Duration(seconds: 30);

  /// Set timeout
  static void setTimeout(Duration timeout) {
    _timeout = timeout;
  }

  /// * Lấy HashKey của Android để đăng ký trong dashboard Zalo
  /// * Get HashKey Android for register app in dashboard Zalo
  /// * Dashboard: https://developers.zalo.me/app/{your_app_id}/login
  static Future<String?> getHashKeyAndroid() async {
    if (Platform.isAndroid) {
      final String? rs = await channel.invokeMethod<String?>('getHashKey').setTimeout(_timeout);
      return rs;
    }
    return null;
  }

  /// * Lấy CodeVerifier cho việc xác thực PCKE
  /// * Get CodeVerifier for PCKE authencation
  /// * More info: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-nhap-post-6006
  static String _getCodeVerifier() {
    const int length = 43;
    final Random random = Random.secure();
    final String verifier = base64UrlEncode(List<int>.generate(length, (_) => random.nextInt(256))).split('=')[0];
    return verifier;
  }

  /// * Lấy CodeChallenge cho việc xác thực PCKE
  /// * Get CodeChallenge for PCKE authencation
  /// * More info: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-nhap-post-6006
  static String _getCodeChallenge(String codeVerifier) {
    final String rs = base64UrlEncode(sha256.convert(ascii.encode(codeVerifier)).bytes).split('=')[0];
    return rs;
  }

  /// * Đăng xuất - SDK xóa oauth code trong cache
  /// * Logout - SDK clear oauth code in cache
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/dang-nhap/dang-xuat-post-6020
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-xuat-post-5728
  static Future<void> logout() async {
    await channel.invokeMethod<void>('logout').setTimeout(_timeout);
  }

  /// * Xác minh lại refresh token
  /// * Check validate refresh token
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/dang-nhap/xac-minh-lai-refreshtoken-post-6023
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
    ).setTimeout(_timeout);
    return rs == true;
  }

  /// * Đăng nhập
  /// * Authenticate (with app or webview)
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/dang-nhap/dang-nhap-post-6027
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/dang-nhap/dang-nhap-post-6006
  static Future<Map<dynamic, dynamic>?> login({
    String? refreshToken,
    Map<String, dynamic> externalInfo = const <String, dynamic>{},
  }) async {
    final String codeVerifier = ZaloFlutter._getCodeVerifier();
    final String codeChallenge = ZaloFlutter._getCodeChallenge(codeVerifier);
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'login',
      <String, dynamic>{
        'codeVerifier': codeVerifier,
        'codeChallenge': codeChallenge,
        'extInfo': externalInfo,
        'refreshToken': refreshToken,
      },
    ).setTimeout(_timeout);
    return rs;
  }

  /// * Lấy thông tin người dùng
  /// * Get Zalo user profile
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-thong-tin-profile-post-6050
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-thong-tin-profile-post-5736
  /// * More info Web: https://developers.zalo.me/docs/api/open-api/tai-lieu/thong-tin-nguoi-dung-post-28
  static Future<Map<dynamic, dynamic>?> getUserProfile({
    required String accessToken,
  }) async {
    final String newAccessToken = accessToken == '' ? 'x' : accessToken;
    final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'getUserProfile',
      <String, dynamic>{
        'accessToken': newAccessToken,
      },
    ).setTimeout(_timeout);
    return rs;
  }
}

// /// * Sử dụng cho OA (đang nghiên cứu)
// /// * Use for OA (studying)
// class ZaloOAFlutter {
//   ZaloOAFlutter._();
//   static const MethodChannel channel = MethodChannel('zalo_flutter');

//   /// * Lấy danh sách bạn bè (đã sử dụng ứng dụng)
//   /// * Get Zalo user friend list (used app)
//   /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-danh-sach-ban-be-post-437
//   /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-danh-sach-ban-be-zalo-post-5813
//   static Future<Map<dynamic, dynamic>?> getUserFriendList({
//     required String accessToken,
//     required int atOffset,
//     required int count,
//   }) async {
//     final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
//       'getUserFriendList',
//       <String, dynamic>{
//         'accessToken': accessToken,
//         'atOffset': atOffset,
//         'count': count,
//       },
//     );
//     return rs;
//   }

//   /// * Lấy danh sách bạn bè (chưa sử dụng ứng dụng)
//   /// * Get Zalo user friend list (not used app)
//   /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-danh-sach-ban-be-post-437
//   /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-danh-sach-ban-be-zalo-post-5813
//   static Future<Map<dynamic, dynamic>?> getUserInvitableFriendList({
//     required String accessToken,
//     required int atOffset,
//     required int count,
//   }) async {
//     final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
//       'getUserInvitableFriendList',
//       <String, dynamic>{
//         'accessToken': accessToken,
//         'atOffset': atOffset,
//         'count': count,
//       },
//     );
//     return rs;
//   }

//   /// * Gửi tin nhắn tới bạn bè
//   /// * Send message to a friend
//   /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/gui-tin-nhan-toi-ban-be-post-1205
//   /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/gui-tin-nhan-cho-ban-be-post-5825
//   static Future<Map<dynamic, dynamic>?> sendMessage({
//     required String accessToken,
//     required String to,
//     required String message,
//     String? link,
//   }) async {
//     final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
//       'sendMessage',
//       <String, dynamic>{
//         'accessToken': accessToken,
//         'to': to,
//         'message': message,
//         'link': link,
//       },
//     );
//     return rs;
//   }

//   /// * Đăng bài viết
//   /// * Post feed
//   /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/dang-bai-viet-post-1212
//   /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/dang-bai-viet-post-1248
//   static Future<Map<dynamic, dynamic>?> postFeed({
//     required String accessToken,
//     required String message,
//     String? link,
//   }) async {
//     final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
//       'postFeed',
//       <String, dynamic>{
//         'accessToken': accessToken,
//         'message': message,
//         'link': link,
//       },
//     );
//     return rs;
//   }

//   /// * Mời sử dụng ứng dụng
//   /// * Send app request
//   /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/moi-su-dung-ung-dung-post-1218
//   /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/moi-su-dung-ung-dung-post-1251
//   static Future<Map<dynamic, dynamic>?> sendAppRequest({
//     required String accessToken,
//     required List<String> to,
//     required String message,
//   }) async {
//     final Map<dynamic, dynamic>? rs = await channel.invokeMethod<Map<dynamic, dynamic>?>(
//       'sendAppRequest',
//       <String, dynamic>{
//         'accessToken': accessToken,
//         'to': to,
//         'message': message,
//       },
//     );
//     return rs;
//   }
// }

extension _InvokeMethodExt<T> on Future<T> {
  Future<T?> setTimeout(Duration timeout, {FutureOr<T> Function()? onTimeout}) async {
    try {
      return await this.timeout(timeout, onTimeout: onTimeout);
    } catch (e) {
      return null;
    }
  }
}
