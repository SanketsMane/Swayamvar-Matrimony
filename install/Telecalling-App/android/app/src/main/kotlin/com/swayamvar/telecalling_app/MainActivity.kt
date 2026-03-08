package com.swayamvar.telecalling_app

import android.view.WindowManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Sanket: Restrict screenshots and screen recording natively
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
