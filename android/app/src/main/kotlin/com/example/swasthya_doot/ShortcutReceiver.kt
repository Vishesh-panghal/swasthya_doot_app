package com.example.swasthya_doot

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

class ShortcutReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        Toast.makeText(context, "🚨 Emergency Shortcut Triggered", Toast.LENGTH_SHORT).show()

        val serviceIntent = Intent(context, EmergencyService::class.java)
        context.startForegroundService(serviceIntent)
    }
}