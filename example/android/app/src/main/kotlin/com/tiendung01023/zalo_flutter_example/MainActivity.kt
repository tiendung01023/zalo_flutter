package com.tiendung01023.zalo_flutter_example

import android.content.Intent
import com.zing.zalo.zalosdk.oauth.ZaloSDK // <-- Add this line
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        super.onActivityResult(requestCode, resultCode, data)
        ZaloSDK.Instance.onActivityResult(this, requestCode, resultCode, data) // <-- Add this
    }
}
