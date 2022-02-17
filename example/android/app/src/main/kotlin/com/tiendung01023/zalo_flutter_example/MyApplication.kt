package com.tiendung01023.zalo_flutter_example

import androidx.startup.AppInitializer
import com.zing.zalo.zalosdk.oauth.ZaloSDKApplication
import io.flutter.app.FlutterApplication
import net.danlew.android.joda.JodaTimeInitializer

class MyApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        ZaloSDKApplication.wrap(this)
        AppInitializer.getInstance(this).initializeComponent(JodaTimeInitializer::class.java)
    }
}
