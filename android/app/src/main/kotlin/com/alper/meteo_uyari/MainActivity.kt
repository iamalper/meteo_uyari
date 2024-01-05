package com.alper.meteo_uyari

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.RemoteException
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "meteo-uyari").setMethodCallHandler {
            call, result ->
            when(call.method) {
                "initChannel" -> {
                    val channelId = call.argument<String>("channelId");
                    val channelName = call.argument<String>("channelName");
                    if (channelId==null || channelName==null) {
                        result.error("argument-error", null, null)
                        return@setMethodCallHandler;
                    }
                    val importance = NotificationManager.IMPORTANCE_HIGH
                    val mChannel = NotificationChannel(channelId, channelName, importance)
                    val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                    try {
                        notificationManager.createNotificationChannel(mChannel)
                    } catch (e:RemoteException) {
                        result.error("channelError",null,null)
                        return@setMethodCallHandler;
                    }
                    result.success(null);
                }
                else -> result.notImplemented()
            }
        }
    }
}
