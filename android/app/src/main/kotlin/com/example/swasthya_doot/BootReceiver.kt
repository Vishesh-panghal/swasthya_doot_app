package com.example.swasthya_doot

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            Log.d("BootReceiver", "Boot completed received")

            // ✅ Only log boot complete — don't trigger EmergencyService directly
            // If needed, add conditional logic later based on user preference or settings
        }
    }
}