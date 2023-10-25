import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/models/city.dart';

FirebaseFirestore? get _db {
  try {
    final instance = FirebaseFirestore.instance;
    log("Firestore initalised", name: "Firestore");
    return instance;
  } on FirebaseException catch (_) {
    //Omits error for testing UI with unsupported platforms.
    log("Firestore couldn't initalised", name: "Firestore");
    return null;
  }
}

Future<List<Alert>> getAlerts(List<City> cities) async {
  final db = _db;
  if (db == null) {
    //For tests
    if (cities.length < 2) return [];
    return [
      Alert(
          description: "Test açıklaması",
          severity: Severity.yellow,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          no: "123123",
          hadise: Hadise.rain,
          towns: [cities[1].centerIdInt]),
      Alert(
          description:
              "Test açıklaması 1 uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun",
          severity: Severity.orange,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          no: "123124",
          hadise: Hadise.cold,
          towns: cities.length >= 3 ? [cities[2].centerIdInt] : []),
      Alert(
          description:
              "Test açıklaması 2 uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun",
          severity: Severity.red,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          no: "123125",
          hadise: Hadise.wind,
          towns: cities.length >= 4 ? [cities[3].centerIdInt] : []),
    ];
  } else {
    final result = await db
        .collection("alerts")
        .where("towns",
            arrayContains: cities.map((e) => int.parse(e.centerId)).toList())
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
