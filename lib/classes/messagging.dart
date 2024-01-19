///Handle Firebase Cloud Messaging api methods
///
///Includes methods which are only work on FCM api.
library;

import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meteo_uyari/models/alert.dart';
import '../models/city.dart';
import '../models/town.dart';

///Get default [FirebaseMessaging] instance
///
///Returns [null] in unsupported platforms.
final _messaging = () {
  try {
    final instance = FirebaseMessaging.instance;
    log("Firebase messagging initalised", name: "messagging");
    return instance;
  } on FirebaseException catch (_) {
    //Omit error for testing UI for unsupported platforms.
    log("Firebase messagging couldn't initalised", name: "messagging");
    return null;
  }
}();

final onForegroundAlert = FirebaseMessaging.onMessage
    .transform(_messageToAlertTransformer)
    .asBroadcastStream();

///Returns cloud messaging token for notifications.
///
///Returns [null] in unsupported platforms
Future<String?> getFcmToken() async => _messaging?.getToken();

///Setup push notifications for [city] and it's towns.
///
///Returns [false] if permission denied by user.
///
///For unsupported platforms, skips setup, returns [true].
@Deprecated("App no longer use cities. Use setupForTown instead")
Future<bool> setup(City city) async {
  final messaging = _messaging;
  if (messaging == null) return true;
  final result = await getPermission();
  if (result) {
    var futures = <Future<void>>[];
    futures.add(messaging.subscribeToTopic(city.centerId.toString()));
    final towns = city.towns;
    for (var town in towns) {
      futures.add(messaging.subscribeToTopic(town.id.toString()));
    }
    await Future.wait(futures);
    return true;
  } else {
    return false;
  }
}

///Setup push notifications for [town].
///
///Returns [false] if permission denied by user.
///
///For unsupported platforms, skips setup, returns [true].
Future<bool> setupForTown(Town town) async {
  final messaging = _messaging;
  if (messaging == null) return true;
  final result = await getPermission();
  if (result) {
    await messaging.subscribeToTopic(town.id.toString());
    return true;
  } else {
    return false;
  }
}

///Unsubscribe from push notifications for [city] and it's towns.
///
///It has no effect if wasn't subscribed to [city] or calling
///from unsupported platforms.
@Deprecated("App no longer use cities. Use unsubscribeFromTown instead")
Future<void> unsubscribeFromCity(City city) async {
  final messaging = _messaging;
  if (messaging != null) {
    final towns = city.towns;
    final futures = {
      messaging.unsubscribeFromTopic(city.centerId),
      ...{
        for (final town in towns)
          messaging.unsubscribeFromTopic(town.id.toString())
      }
    };
    await Future.wait(futures);
  }
}

///Unsubscribe from push notifications for [town].
///
///It has no effect if wasn't subscribed to [town] or calling
///from unsupported platforms.
Future<void> unsubscribeFromTown(Town town) async {
  final messaging = _messaging;
  if (messaging != null) {
    await messaging.unsubscribeFromTopic(town.id.toString());
  }
}

///Get notification permission from user.
///
///For Android, it automatically given unless manually revoked by user.
///
///For unsupported platforms, always returns [true]
Future<bool> getPermission() async {
  final messaging = _messaging;
  if (messaging == null) return true;
  final result = await messaging.requestPermission();
  return (result.authorizationStatus != AuthorizationStatus.denied);
}

///Returns if notification permissions granted by the user.
///
///Request permission first with [getPermission()] or [setup()]
///
///For unsupported platforms, always returns [true]
Future<bool> isPermissionGranted() async {
  final messaging = _messaging;
  if (messaging == null) return true;
  return (await messaging.getNotificationSettings()).authorizationStatus ==
      AuthorizationStatus.authorized;
}

final _messageToAlertTransformer =
    StreamTransformer<RemoteMessage, Alert>.fromBind((messageStream) async* {
  await for (final message in messageStream) {
    final alertMap = message.data;
    if (alertMap["no"] == null) {
      log("Foreground Message does not contain alert data");
      continue;
    }
    log("Got foreground Alert message,$alertMap");
    final alert = Alert.fromMap(alertMap);
    yield alert;
  }
});
