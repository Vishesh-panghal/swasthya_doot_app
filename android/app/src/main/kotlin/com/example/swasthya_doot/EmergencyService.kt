package com.example.swasthya_doot

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.widget.Toast
import android.util.Log
import android.net.Uri
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices

class EmergencyService : Service() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()

        val notification: Notification = NotificationCompat.Builder(this, "emergency_channel")
            .setContentTitle("Emergency Service Active")
            .setContentText("Sending location to emergency contacts")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

        startForeground(1, notification)

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        fusedLocationClient.lastLocation
            .addOnSuccessListener { location: Location? ->
                if (location != null) {
                    sendWhatsAppMessage(location)
                } else {
                    Toast.makeText(this, "Unable to get location", Toast.LENGTH_SHORT).show()
                }
            }
            .addOnFailureListener {
                Toast.makeText(this, "Location fetch failed", Toast.LENGTH_SHORT).show()
            }

        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                "emergency_channel",
                "Emergency Service Channel",
                NotificationManager.IMPORTANCE_HIGH,
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(serviceChannel)
        }
    }

    private fun sendWhatsAppMessage(location: Location) {
        val latitude = location.latitude
        val longitude = location.longitude

        val locationUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude"
        val message = "🚨 Emergency! My current location is:\n$locationUrl"

        val phoneNumbers = listOf("919306078820", "91XXXXXXXXXX", "91YYYYYYYYYY")

        for (number in phoneNumbers) {
            val uri = Uri.parse("https://wa.me/$number?text=" + Uri.encode(message))
            val sendIntent = Intent(Intent.ACTION_VIEW, uri)
            sendIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            try {
                startActivity(sendIntent)
            } catch (e: Exception) {
                Log.e("EmergencyService", "WhatsApp not installed for $number", e)
                Toast.makeText(this, "WhatsApp not installed for $number", Toast.LENGTH_SHORT).show()
            }
        }

        stopSelf()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}