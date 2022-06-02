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
            ZaloSDK.sharedInstance().initialize(withAppId: zaloAppID)
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
        case "validateRefreshToken":
            validateRefreshToken(call, result)
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
        case "shareMessage":
            shareMessage(call, result)
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
    
    func validateRefreshToken(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let refreshToken = arguments["refreshToken"] as! String
        let extInfo = arguments["extInfo"] as? [AnyHashable : Any]
        
        ZaloSDK.sharedInstance().validateRefreshToken(refreshToken, extInfo: extInfo) { (response) in
            result(response?.isSucess == true)
        }
    }
    
    func login(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let extInfo = arguments["extInfo"] as? [AnyHashable : Any]
        let refreshToken = arguments["refreshToken"] as? String

        if refreshToken != nil {
            ZaloSDK.sharedInstance().validateRefreshToken(refreshToken, extInfo: extInfo) { (response) in
                if response?.isSucess == true {
                    ZaloSDK.sharedInstance().getAccessToken(withRefreshToken: refreshToken, completionHandler: self.withZOTokenResponseObjectCallBack(result: result))
                } else {
                    self._loginWithoutRefreshToken(call, result)
                }
            }
        } else {
            self._loginWithoutRefreshToken(call, result)
        }
    }

    func _loginWithoutRefreshToken(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let codeVerifier = arguments["codeVerifier"] as! String
        let codeChallenge = arguments["codeChallenge"] as! String
        let extInfo = arguments["extInfo"] as? [AnyHashable : Any]
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: rootViewController, codeChallenge: codeChallenge, extInfo: extInfo) { (authenResponse) in
            if let authenResponse = authenResponse {
                let errorCode = authenResponse.errorCode
                let errorMessage = authenResponse.errorMessage
                let oauthCode = authenResponse.oauthCode
                if (authenResponse.isSucess == true) {
                    ZaloSDK.sharedInstance().getAccessToken(withOAuthCode: oauthCode, codeVerifier: codeVerifier, completionHandler: self.withZOTokenResponseObjectCallBack(result: result))
                } else {
                    let error : [String : Any?] = [
                        "errorCode": errorCode,
                        "errorMessage": errorMessage,
                    ]
                    let map : [String : Any?] = [
                        "isSuccess": false,
                        "error": error
                    ]
                    result(map)
                }
            } else {
                let error : [String : Any?] = [
                    "errorCode": -9999,
                    "errorMessage": "Other error: authenticateZalo - cannot get response",
                ]
                
                let map : [String : Any?] = [
                    "isSuccess": false,
                    "error": error
                ]
                result(map)
            }
        }
    }

    func getUserProfile(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let accessToken = arguments["accessToken"] as! String
        ZaloSDK.sharedInstance().getZaloUserProfile(withAccessToken: accessToken) { (response) in
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
        let accessToken = arguments["accessToken"] as! String
        let atOffset = arguments["atOffset"] as! UInt
        let count = arguments["count"] as! UInt

        ZaloSDK.sharedInstance().getUserFriendList(atOffset: atOffset, count: count, accessToken: accessToken, callback: withZOGraphCallBack(result: result))
    }
    
    func getUserInvitableFriendList(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let accessToken = arguments["accessToken"] as! String
        let atOffset = arguments["atOffset"] as! UInt
        let count = arguments["count"] as! UInt

        ZaloSDK.sharedInstance().getUserInvitableFriendList(atOffset: atOffset, count: count, accessToken: accessToken, callback: withZOGraphCallBack(result: result))
    }
    
    func sendMessage(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let accessToken = arguments["accessToken"] as! String
        let to = arguments["to"] as? String ?? ""
        let message = arguments["message"] as? String ?? ""
        let link = arguments["link"] as? String ?? ""

        ZaloSDK.sharedInstance().sendMessage(to: to, message: message, link: link, accessToken: accessToken, callback: withZOGraphCallBack(result: result))
    }
    
    func postFeed(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let accessToken = arguments["accessToken"] as! String
        let message = arguments["message"] as? String ?? ""
        let link = arguments["link"] as? String ?? ""

        ZaloSDK.sharedInstance().postFeed(withMessage: message, link: link, accessToken: accessToken, callback: withZOGraphCallBack(result: result))
    }
    
    func sendAppRequest(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let accessToken = arguments["accessToken"] as! String
        let listTo = arguments["to"] as! Array<String>;
        let to = listTo.joined(separator: ",")
        let message = arguments["message"] as? String ?? ""
        
        ZaloSDK.sharedInstance().sendAppRequest(to: to, message: message, accessToken: accessToken, callback: withZOGraphCallBack(result: result))
    }
    
    func shareMessage(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let viewController: UIViewController =
                    (UIApplication.shared.delegate?.window??.rootViewController)!;
        let arguments = call.arguments as! Dictionary<String, Any>
        let link = arguments["link"] as! String
        let message = arguments["message"] as! String
        let appName = arguments["appName"] as! String
        let feed = ZOFeed(
                link: link,
                appName: appName,
                message: message,
                others: nil
        )
        ZaloSDK.sharedInstance().sendMessage(feed, in: viewController, callback: nil)
        result(true)
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
    
    func withZOTokenResponseObjectCallBack(result: @escaping FlutterResult) -> (ZOTokenResponseObject?) -> Void {
        return { (response) -> Void in
            if let response = response {
                let errorCode = response.errorCode // mã lỗi trả về, thành công khi >= 0
                let errorMessage = response.errorMessage // câu thông báo lỗi
                let accessToken = response.accessToken // dùng để gọi các Official Account API.
                let refreshToken = response.refreshToken // lưu lại RefreshToken ở phía app để tạo lại AccessToken khi AccessToken hết hiệu lực.Hiệu lực: 3 tháng
                let expriedTime = response.expriedTime // thời gian AccessToken hết hiệu lực.
                if response.isSucess {
                    let data : [String : Any?] = [
                        "accessToken": accessToken,
                        "refreshToken": refreshToken,
                        "expriedTime": expriedTime,
                    ]
                    
                    let map : [String : Any?] = [
                        "isSuccess": response.isSucess,
                        "data": data
                    ]
                    result(map)
                } else {
                    let error : [String : Any?] = [
                        "errorCode": errorCode,
                        "errorMessage": errorMessage,
                    ]
                    
                    let map : [String : Any?] = [
                        "isSuccess": false,
                        "error": error
                    ]
                    result(map)
                }
            } else {
                // Get AccessToken lỗi
                let error : [String : Any?] = [
                    "errorCode": -9998,
                    "errorMessage": "Other error: getAccessToken - cannot get response",
                ]
                let map : [String : Any?] = [
                    "isSuccess": false,
                    "error": error
                ]
                result(map)
            }
        };
    }
}
