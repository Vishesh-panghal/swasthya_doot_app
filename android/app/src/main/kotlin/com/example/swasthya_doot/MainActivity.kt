package com.example.swasthya_doot

import android.content.Intent
import android.os.Bundle
import android.view.KeyEvent
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "emergency_channel"

    private var volumePressCount = 0
    private var lastPressTime: Long = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "startEmergencyService") {
                val intent = Intent(this, EmergencyService::class.java)
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    startForegroundService(intent)
                } else {
                    startService(intent)
                }
                result.success("Emergency service started")
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        val currentTime = System.currentTimeMillis()

        if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN || keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
            if (currentTime - lastPressTime <= 1500) {
                volumePressCount++
                if (volumePressCount >= 4) {
                    triggerEmergency()
                    volumePressCount = 0
                }
            } else {
                volumePressCount = 1
            }
            lastPressTime = currentTime
        }

        return super.onKeyDown(keyCode, event)
    }

    private fun triggerEmergency() {
        Toast.makeText(this, "🚨 Emergency triggered! Sending location...", Toast.LENGTH_SHORT).show()

        val intent = Intent(this, EmergencyService::class.java)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }
}
