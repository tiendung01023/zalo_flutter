#import "ZaloFlutterPlugin.h"
#if __has_include(<zalo_flutter/zalo_flutter-Swift.h>)
#import <zalo_flutter/zalo_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "zalo_flutter-Swift.h"
#endif

@implementation ZaloFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZaloFlutterPlugin registerWithRegistrar:registrar];
}
@end
