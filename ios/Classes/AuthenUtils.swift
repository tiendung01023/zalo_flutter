//
//  AuthenUtils.swift
//  zalo_flutter
//
//  Created by Phong Phong on 14/02/2022.
//

import Foundation
import ZaloSDK

class AuthenUtils {
    
    static let shared = AuthenUtils()
    var tokenResponse: ZOTokenResponseObject?
    var codeChallenage = ""
    var codeVerifier = ""
    
    
    func getAccessToken(_ completionHandler: @escaping (String?) -> ()) {
        let now = TimeInterval(Date().timeIntervalSince1970 - 10)
        if let tokenResponse = tokenResponse,
           let accessToken = tokenResponse.accessToken, !accessToken.isEmpty,
           tokenResponse.expriedTime > now {
            
            completionHandler(accessToken)
            return
        }
        let refreshToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.refreshToken.rawValue)
        ZaloSDK.sharedInstance().getAccessToken(withRefreshToken: refreshToken) { (response) in
            self.saveTokenResponse(response)
            completionHandler(response?.accessToken)
        }
    }
    
    func saveTokenResponse(_ tokenResponse: ZOTokenResponseObject?) {
        guard let tokenResponse = tokenResponse else {
            return
        }
        self.tokenResponse = tokenResponse
        let userDefault = UserDefaults.standard
        userDefault.set(tokenResponse.accessToken, forKey: UserDefaultsKeys.accessToken.rawValue)
        userDefault.set(tokenResponse.refreshToken, forKey: UserDefaultsKeys.refreshToken.rawValue)
    }
    
    func logout() {
        let allKeys = UserDefaultsKeys.allCases;
        let userDefault = UserDefaults.standard
        for key in allKeys {
            userDefault.removeObject(forKey: key.rawValue)
        }
        self.tokenResponse = nil
    }
    
    func getCodeChallenge() -> String {
        return self.codeChallenage
    }
    
    func getCodeVerifier() -> String {
        return self.codeVerifier
    }
    
    func renewPKCECode() {
        self.codeVerifier = generateCodeVerifier() ?? ""
        self.codeChallenage = generateCodeChallenge(codeVerifier: self.codeVerifier) ?? ""
    }
}
