import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteo_uyari/models/alert.dart';

FirebaseFirestore? get _db {
  try {
    final instance = FirebaseFirestore.instance;
    log("Firestore initalised", name: "Firestore");
    return instance;
  } on FirebaseException catch (_) {
    log("Firestore couldn't initalised", name: "Firestore");
    return null;
  }
}

Future<List<Alert>> getAlerts(int cityId) async {
  final db = _db;
  if (db == null) {
    return [
      Alert(
          description: "Test açıklaması",
          severity: Severity.yellow,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          no: "123123",
          hadise: Hadise.rain,
          towns: [cityId.toString()]),
      Alert(
          description:
              "Test açıklaması 1 uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun",
          severity: Severity.orange,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          no: "123124",
          hadise: Hadise.cold,
          towns: [cityId.toString()]),
      Alert(
          description:
              "Test açıklaması 2 uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun",
          severity: Severity.red,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          no: "123125",
          hadise: Hadise.wind,
          towns: [cityId.toString()]),
    ];
  } else {
    final result = await db
        .collection("alerts")
        .where("towns", arrayContains: cityId)
        .withConverter(
          fromFirestore: (snapshot, _) => Alert.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap,
        )
        .get();
    final alerts = result.docs.map((e) => e.data()).toList();
    log("Got alerts: $alerts", name: "Firestore");
    return alerts;
  }
}
