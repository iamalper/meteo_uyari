///Handle Firebase Cloud Messaging api methods
///
///Includes methods which are only work on FCM api.
library;

import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/city.dart';

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

///Returns cloud messaging token for notifications.
///
///Returns [null] in unsupported platforms
Future<String?> getFcmToken() async => _messaging?.getToken();

///Setup push notifications for [city] and it's towns.
///
///Returns [false] if permission denied by user.
///
///For unsupported platforms, skips setup, returns [true].
Future<bool> setup(City city) async {
  final messaging = _messaging;
  if (messaging == null) return true;
  final result = await getPermission();
  if (result) {
    var futures = <Future<void>>[];
    futures.add(messaging.subscribeToTopic(city.centerId.toString()));
    final towns = city.towns;
    if (towns != null) {
      for (var town in towns) {
        futures.add(messaging.subscribeToTopic(town.id.toString()));
      }
    }
    await Future.wait(futures);
    return true;
  } else {
    return false;
  }
}

///Unsubscribe from push notifications for [city] and it's towns.
///
///It has no effect if wasn't subscribed to [city] or calling
///from unsupported platforms.
Future<void> unsubscribeFromCity(City city) async {
  final messaging = _messaging;
  if (messaging != null) {
    final towns = city.towns;
    final futures = {
      messaging.unsubscribeFromTopic(city.centerId),
      if (towns != null) ...{
        for (final town in towns)
          messaging.unsubscribeFromTopic(town.id.toString())
      }
    };
    await Future.wait(futures);
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
