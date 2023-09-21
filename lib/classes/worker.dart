import 'dart:developer';

import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:workmanager/workmanager.dart';
import 'helpers.dart' as helpers;
import 'database.dart' as database;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _initalizationSettings = InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"));
const _androidChannel = AndroidNotificationChannel("MeteoUyari", "MeteoUyarı");
@pragma('vm:entry-point')
void workManagerCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case "check_alerts":
        try {
          await FlutterLocalNotificationsPlugin()
              .initialize(_initalizationSettings);
          final townId = inputData!["int"] as int;
          final alerts = await helpers.getAlerts(townId);
          if (alerts.isNotEmpty) {
            for (var alert in alerts) {
              final isNew = await database.checkAlertIsNew(alert.alertNo);
              if (isNew) {
                log("New alert reveived: $alert", name: "Worker");
                await FlutterLocalNotificationsPlugin().show(
                    alert.hashCode,
                    "Hava Uyarısı",
                    alert.description,
                    NotificationDetails(
                        android: AndroidNotificationDetails(
                            _androidChannel.id, _androidChannel.name)));
                await database.insertAlert(alert.alertNo);
                await database.closeDb();
              } else {
                log("Old alert received: $alert", name: "Worker");
              }
            }
            await database.closeDb();
          }
          return true;
        } catch (_) {
          rethrow;
        }

      default:
        throw Error();
    }
  });
}

///Requests notification permission then initalizes work manager.
///
///If [debugNotifications] true, a notification shown after periodic task.
///
///Throws [NoNotificationPermissionException] if permission denied.
Future<void> initalizeWorkmanager({bool debugNotifications = false}) async {
  final permission = await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  if (permission == null || permission == false) {
    throw NoNotificationPermissionException();
  }
  await Workmanager()
      .initialize(workManagerCallback, isInDebugMode: debugNotifications);
}

///Register alerts for [townId]
///
///Make sure to call [initalizeWorkmanager] before.
Future<void> registerAlerts(
  int townId,
) =>
    Workmanager().registerPeriodicTask("check_alerts", "check_alerts",
        inputData: {"int": townId},
        constraints: Constraints(networkType: NetworkType.unmetered));

Future<void> cancelWorks() => Workmanager().cancelAll();
