import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/city.dart';

FirebaseMessaging? get _messagging {
  try {
    final instance = FirebaseMessaging.instance;
    log("Firebase messagging initalised", name: "messagging");
    return instance;
  } on FirebaseException catch (_) {
    //Omit error for testing UI for unsupported platforms.
    log("Firebase messagging couldn't initalised", name: "messagging");
    return null;
  }
}

Future<String?> get fcmToken async => _messagging?.getToken();

///Setup push notifications for [city] and it's towns.
///
///Returns [false] if permission denied by user.
///
///For unsupported platforms, skips setup, returns [true].
Future<bool> setup(City city) async {
  final messaging = _messagging;
  if (messaging == null) return true;
  final result = await getPermission();
  if (result) {
    var futures = <Future<void>>[];
    futures.add(messaging.subscribeToTopic(city.centerId.toString()));
    final towns = city.towns;
    if (towns != null) {
      for (var town in towns) {
        futures.add(messaging.subscribeToTopic(town.toString()));
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
  final messaging = _messagging;
  if (messaging != null) {
    var futures = <Future<void>>[];
    futures.add(messaging.unsubscribeFromTopic(city.centerId));
    final towns = city.towns;
    if (towns != null) {
      futures.addAll(
          towns.map((e) => messaging.unsubscribeFromTopic(e.id.toString())));
    }
    await Future.wait(futures);
  }
}

///Get notification permission from user.
///
///For Android, it automatically given unless manually revoked by user.
///
///For unsupported platforms, always returns [true]
Future<bool> getPermission() async {
  final messaging = _messagging;
  if (messaging == null) return true;
  final result = await messaging.requestPermission();
  return (result.authorizationStatus != AuthorizationStatus.denied);
}

///Returns if notification permissions granted by the user.
///
///Request permission with [getPermission()] or [setup()]
///
///For unsupported platforms, always returns [true]
Future<bool> isPermissionGranted() async {
  final messaging = _messagging;
  if (messaging == null) return true;
  return (await messaging.getNotificationSettings()).authorizationStatus ==
      AuthorizationStatus.authorized;
}
