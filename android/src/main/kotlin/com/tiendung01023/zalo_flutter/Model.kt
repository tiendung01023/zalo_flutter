package com.tiendung01023.zalo_flutter

import org.json.JSONObject

data class ZOTokenResponseObject(
    val accessToken: String?,
    val refreshToken: String?,
    val expiresIn: Long,
) {
    companion object {
        fun fromJson(data: JSONObject) = ZOTokenResponseObject(
            accessToken = data.optString("access_token"),
            refreshToken = data.optString("refresh_token"),
            expiresIn = data.optString("expires_in").toLong(),
        )
    }
}
