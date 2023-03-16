package com.tiendung01023.example

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent // <-- Add this line
import com.zing.zalo.zalosdk.oauth.ZaloSDK // <-- Add this line

class MainActivity: FlutterActivity() {
    override fun onActivityResult(requestCode:Int, resultCode:Int, data: Intent) {
        super.onActivityResult(requestCode, resultCode, data)
        ZaloSDK.Instance.onActivityResult(this, requestCode, resultCode, data) // <-- Add this line
    }
}