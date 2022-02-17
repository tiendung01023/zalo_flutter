package com.tiendung01023.zalo_flutter

import android.util.Base64
import java.security.MessageDigest
import java.security.SecureRandom


class AppUtils {
    companion object {

        /// Generating a code verifier for PKCE
        fun generateCodeVerifier(): String {
            val sr = SecureRandom()
            val code = ByteArray(32)
            sr.nextBytes(code)
            return Base64.encodeToString(
                code,
                Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING
            )
        }

        /// Generating a code challenge for PKCE
        fun generateCodeChallenge(verifier: String): String {
            val bytes = verifier.toByteArray()
            val messageDigest = MessageDigest.getInstance("SHA-256")
            messageDigest.update(bytes, 0, bytes.size)
            val digest = messageDigest.digest()
            return Base64.encodeToString(
                digest,
                Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING
            )
        }

    }
}


fun main() {
    AppUtils.generateCodeChallenge(AppUtils.generateCodeVerifier())
}
