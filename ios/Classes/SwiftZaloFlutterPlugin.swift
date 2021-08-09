import Flutter
import UIKit
import ZaloSDK
import os

public class SwiftZaloFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "zalo_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftZaloFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        /// Zalo sdk
        if let zaloAppID = Bundle.main.infoDictionary?["ZaloAppID"] as? String {
            ZaloSDK.sharedInstance()?.initialize(withAppId: zaloAppID)
        } else {
            if #available(iOS 10.0, *) {
                os_log("🆘🆘🆘====> You haven't added ZaloAppID to Info.plist <====🆘🆘🆘")
            } else {
                NSLog("🆘🆘🆘====> You haven't added ZaloAppID to Info.plist <====🆘🆘🆘")
            }
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("Xcode handle: \(call.method)")
        switch call.method {
        case "getHashKey":
            result(nil)
        case "logout":
            logout(call, result)
            break
        case "isAuthenticated":
            isAuthenticated(call, result)
            break
        case "login":
            login(call, result)
            break
        case "getUserProfile":
            getUserProfile(call, result)
            break
        case "getUserFriendList":
            getUserFriendList(call, result)
            break
        case "getUserInvitableFriendList":
            getUserInvitableFriendList(call, result)
            break
        case "sendMessage":
            sendMessage(call, result)
            break
        case "postFeed":
            postFeed(call, result)
            break
        case "sendAppRequest":
            sendAppRequest(call, result)
            break
        default:
            result("Not implement")
            break
        }
    }
    
    func logout(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        ZaloSDK.sharedInstance().unauthenticate()
        result(nil)
    }
    
    func isAuthenticated(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        ZaloSDK.sharedInstance().isAuthenticatedZalo { (response) in
            result(response?.isSucess == true)
        }
    }
    
    func login(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let rootViewController  = UIApplication.shared.keyWindow?.rootViewController
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: rootViewController) { (response) in
            if let response = response {
                let error : [String : Any?] = [
                    "errorCode": response.errorCode,
                    "errorMessage": response.errorMessage,
                ]
                let data : [String : Any?] = [
                    "oauthCode": response.oauthCode,
                    "userId": response.userId,
                    "displayName": response.displayName,
                    "phoneNumber": response.phoneNumber,
                    "dob": response.dob,
                    "gender": response.gender,
                    
                    "zcert": response.zcert,
                    "zprotect": response.zprotect,
                    "isRegister": response.isRegister,
                    
                    "type": self.getTypeName(response.type),
                    "facebookAccessToken": response.facebookAccessToken,
                    "facebookAccessTokenExpiredDate": response.facebookAccessTokenExpiredDate,
                    "socialId": response.socialId,
                ]
                let map : [String : Any?] = [
                    "isSuccess": response.isSucess,
                    "error": error,
                    "data": data
                ]
                result(map)
            } else {
                result(nil)
            }
        }
    }
    
    func getUserProfile(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        ZaloSDK.sharedInstance().getZaloUserProfile { (response) in
            if let response = response {
                let error : [String : Any?] = [
                    "errorCode": response.errorCode,
                    "errorMessage": response.errorMessage,
                ]
                let data = response.data
                let map : [String : Any?] = [
                    "isSuccess": response.isSucess,
                    "error": error,
                    "data": data
                ]
                result(map)
            } else {
                result(nil)
            }
        }
    }
    
    func getUserFriendList(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let atOffset = arguments["atOffset"] as! UInt
        let count = arguments["count"] as! UInt
        ZaloSDK.sharedInstance().getUserFriendList(atOffset: atOffset, count: count, callback: withZOGraphCallBack(result: result))
    }
    
    func getUserInvitableFriendList(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let atOffset = arguments["atOffset"] as! UInt
        let count = arguments["count"] as! UInt
        ZaloSDK.sharedInstance().getUserInvitableFriendList(atOffset: atOffset, count: count, callback: withZOGraphCallBack(result: result))
    }
    
    func sendMessage(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let to = arguments["to"] as! String
        let message = arguments["message"] as? String
        let link = arguments["link"] as? String
        ZaloSDK.sharedInstance().sendMessage(to: to, message: message, link: link, callback: withZOGraphCallBack(result: result))
    }
    
    func postFeed(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let message = arguments["message"] as? String
        let link = arguments["link"] as? String
        ZaloSDK.sharedInstance().postFeed(withMessage: message, link: link, callback: withZOGraphCallBack(result: result))
    }
    
    func sendAppRequest(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let listTo = arguments["to"] as! Array<String>;
        let to = listTo.joined(separator: ",")
        let message = arguments["message"] as? String
        ZaloSDK.sharedInstance().sendAppRequest(to: to, message: message, callback: withZOGraphCallBack(result: result))
    }
    
    
    /// Common
    
    func withZOGraphCallBack(result: @escaping FlutterResult) -> ZOGraphCallback {
        return { (response) -> Void in
            if let response = response {
                let error : [String : Any?] = [
                    "errorCode": response.errorCode,
                    "errorMessage": response.errorMessage,
                ]
                let data = response.data
                let map : [String : Any?] = [
                    "isSuccess": response.isSucess,
                    "error": error,
                    "data": data
                ]
                result(map)
            } else {
                result(nil)
            }
        };
    }
    
    func getTypeName(_ type: ZOLoginType) -> String? {
        var name:String?
        switch type {
        case .apple:
            name = "APPLE"
            break
        case .facebook:
            name = "FACEBOOK"
            break
        case .googlePlus:
            name = "GOOGLE"
            break
        case .guest:
            name = "GUEST"
            break
        case .unknown:
            name = "UNKNOWN"
            break
        case .zalo:
            name = "ZALO"
            break
        case .zingMe:
            name = "ZINGME"
            break
        default: break
        }
        return name
    }
}
