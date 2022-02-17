package com.tiendung01023.zalo_flutter

import android.content.Context
import com.zing.zalo.zalosdk.oauth.ZaloSDK
import org.joda.time.DateTime

class AuthenUtils {
    companion object {
        val shared = AuthenUtils()
        private var tokenResponse: ZOTokenResponseObject? = null
        private var codeChallenge = ""
        private var codeVerifier = ""
    }

    fun getAccessToken(context: Context, completionHandler: (data: String?) -> Unit) {
        val now = DateTime.now().millis - 10

        if (tokenResponse != null && tokenResponse!!.accessToken != null && tokenResponse!!.accessToken!!.isNotEmpty() && tokenResponse!!.expiresIn > now) {
            tokenResponse!!.accessToken!!.let { completionHandler.invoke(it) }
            return
        }

        val sharedPreferences = context.getSharedPreferences("data", Context.MODE_PRIVATE)
        val refreshToken = sharedPreferences.getString(UserDefaultsKeys.REFRESHTOKEN.name, null)
        ZaloSDK.Instance.getAccessTokenByRefreshToken(context, refreshToken) { data ->
            val response = ZOTokenResponseObject.fromJson(data)
            saveTokenResponse(context, response)
            response.accessToken?.let { completionHandler.invoke(it) }
        }
    }

    fun saveTokenResponse(context: Context, response: ZOTokenResponseObject?) {
        if (response == null) return
        tokenResponse = response
        val sharedPreferences = context.getSharedPreferences("data", Context.MODE_PRIVATE).edit()
        sharedPreferences.putString(UserDefaultsKeys.ACCESSTOKEN.name, response.accessToken)
            .apply()
        sharedPreferences
            .putString(UserDefaultsKeys.REFRESHTOKEN.name, response.refreshToken).apply()
    }

    fun logout(context: Context) {
        val allKeys = UserDefaultsKeys.values()
        val userDefault = context.getSharedPreferences("data", Context.MODE_PRIVATE)
        allKeys.forEach {
            userDefault.edit().remove(it.name).apply()
        }

        tokenResponse = null
    }

    fun getCodeChallenge(): String = codeChallenge

    fun getCodeVerifier(): String = codeVerifier

    fun renewPKCECode() {
        codeVerifier = AppUtils.generateCodeVerifier()
        codeChallenge = AppUtils.generateCodeChallenge(verifier = codeVerifier)
    }

}
