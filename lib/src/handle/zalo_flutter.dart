import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import '../model/model.dart';

class ZaloFlutter {
  static const MethodChannel channel = MethodChannel('zalo_flutter');

  /// * Lấy HashKey của Android để đăng ký trong dashboard Zalo
  /// * Get HashKey Android for register app in dashboard Zalo
  /// * Dashboard: https://developers.zalo.me/app/{your_app_id}/login
  static Future<String?> getHashKeyAndroid() async {
    if (Platform.isAndroid) {
      final String? rs = await channel.invokeMethod<String?>('getHashKey');
      return rs;
    }
  }

  /// * Đăng xuất - SDK xóa oauth code trong cache
  /// * Logout - SDK clear oauth code in cache
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/login/dang-xuat-post-429
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/login/dang-xuat-post-485
  static Future<void> logout() async {
    await channel.invokeMethod<void>('logout');
  }

  /// * Xác minh lại oauth code
  /// * Check if authenticated
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/login/xac-minh-lai-oauth-code-post-427
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/login/xac-minh-lai-oauth-code-post-483
  static Future<bool> isLogin() async {
    final bool? rs = await channel.invokeMethod<bool?>('isAuthenticated');
    return rs == true;
  }

  /// * Đăng nhập
  /// * Authenticate (with app or webview)
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/login/dang-nhap-bang-zalo-post-250
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/login/dang-nhap-post-480
  static Future<ZaloLogin> login() async {
    final Map<dynamic, dynamic>? rs =
        await channel.invokeMethod<Map<dynamic, dynamic>?>('login');
    final ZaloLogin data = ZaloLogin.fromJson(rs);
    return data;
  }

  /// * Lấy thông tin người dùng
  /// * Get Zalo user profile
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-thong-tin-nguoi-dung-post-435
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-thong-tin-profile-post-490
  static Future<ZaloProfile> getUserProfile() async {
    final Map<dynamic, dynamic>? rs =
        await channel.invokeMethod<Map<dynamic, dynamic>?>('getUserProfile');
    final ZaloProfile data = ZaloProfile.fromJson(rs);
    return data;
  }

  /// * Lấy danh sách bạn bè (đã sử dụng ứng dụng)
  /// * Get Zalo user friend list (used app)
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-danh-sach-ban-be-post-437
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-danh-sach-ban-be-zalo-post-492
  static Future<ZaloUserFriend> getUserFriendList({
    required int atOffset,
    required int count,
  }) async {
    final Map<dynamic, dynamic>? rs =
        await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'getUserFriendList',
      <String, dynamic>{
        'atOffset': atOffset,
        'count': count,
      },
    );
    final ZaloUserFriend data = ZaloUserFriend.fromJson(rs);
    return data;
  }

  /// * Lấy danh sách bạn bè (chưa sử dụng ứng dụng)
  /// * Get Zalo user friend list (not used app)
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/lay-danh-sach-ban-be-post-437
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/lay-danh-sach-ban-be-zalo-post-492
  static Future<ZaloUserFriend> getUserInvitableFriendList({
    required int atOffset,
    required int count,
  }) async {
    final Map<dynamic, dynamic>? rs =
        await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'getUserInvitableFriendList',
      <String, dynamic>{
        'atOffset': atOffset,
        'count': count,
      },
    );
    final ZaloUserFriend data = ZaloUserFriend.fromJson(rs);
    return data;
  }

  /// * Gửi tin nhắn tới bạn bè
  /// * Send message to a friend
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/gui-tin-nhan-toi-ban-be-post-1205
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/gui-tin-nhan-cho-ban-be-post-1266
  static Future<ZaloSendMessage> sendMessage({
    required String to,
    required String message,
    String? link,
  }) async {
    final Map<dynamic, dynamic>? rs =
        await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'sendMessage',
      <String, dynamic>{
        'to': to,
        'message': message,
        'link': link,
      },
    );
    final ZaloSendMessage data = ZaloSendMessage.fromJson(rs);
    return data;
  }

  /// * Đăng bài viết
  /// * Post feed
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/dang-bai-viet-post-1212
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/dang-bai-viet-post-1248
  static Future<ZaloPostFeed> postFeed({
    required String message,
    String? link,
  }) async {
    final Map<dynamic, dynamic>? rs =
        await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'postFeed',
      <String, dynamic>{
        'message': message,
        'link': link,
      },
    );
    final ZaloPostFeed data = ZaloPostFeed.fromJson(rs);
    return data;
  }

  /// * Mời sử dụng ứng dụng
  /// * Send app request
  /// * More info Android: https://developers.zalo.me/docs/sdk/android-sdk/open-api/moi-su-dung-ung-dung-post-1218
  /// * More info Ios: https://developers.zalo.me/docs/sdk/ios-sdk/open-api/moi-su-dung-ung-dung-post-1251
  static Future<ZaloSendAppRequest> sendAppRequest({
    required List<String> to,
    required String message,
  }) async {
    final Map<dynamic, dynamic>? rs =
        await channel.invokeMethod<Map<dynamic, dynamic>?>(
      'sendAppRequest',
      <String, dynamic>{
        'to': to,
        'message': message,
      },
    );
    final ZaloSendAppRequest data = ZaloSendAppRequest.fromJson(rs);
    return data;
  }
}
