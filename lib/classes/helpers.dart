import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/database.dart' as database;

import '../models/alert.dart';
import 'requests.dart' as requests;
import 'parsers.dart' as parsers;
import '../models/city.dart';
import '../models/town.dart';
import 'worker.dart' as worker;

///Saves [city], initalises background worker and registers alerts for [city]
Future<void> setNotifications(City city,
    {bool debugNotifications = false}) async {
  await saveCity(city);
  await worker.initalizeWorkmanager(debugNotifications: debugNotifications);
  await worker.registerAlerts(city.centerId);
  log("Notifications set for: $city", name: "Backend");
}

Future<List<City>> getCities() async {
  final response = await requests.requestCities();
  final cities = parsers.parseCities(response);
  log("Got cities: $cities", name: "Backend");
  return cities;
}

Future<City?> getSavedCity() async {
  final result = database.getCity();
  log("Got saved city: $result", name: "Backend");
  return result;
}

///If [city] is null, deletes saved city
Future<void> saveCity(City? city) async {
  final result = database.saveCity(city);
  log("Saved city: $city", name: "Backend");
  return result;
}

///If [uiTest] is `true` returns pre-generated alerts without connecting to api
Future<List<Alert>> getAlerts(int id, {bool uiTest = false}) async {
  final List<Alert> alerts;
  if (uiTest) {
    alerts = [
      Alert(
          description: "Test açıklaması",
          color: Colors.yellow,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          alertNo: "123123"),
      Alert(
          description:
              "Test açıklaması 1 uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun",
          color: Colors.orange,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          alertNo: "123124"),
      Alert(
          description:
              "Test açıklaması 2 uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun uzun",
          color: Colors.red,
          beginTime: DateTime.now(),
          endTime: DateTime.now(),
          alertNo: "123125"),
    ];
  } else {
    final response = await requests.requestAlerts();
    alerts = parsers.parseAlerts(response, id);
  }
  log("Got alerts for $id : $alerts", name: "Backend");
  return alerts;
}

Future<List<Town>> getTowns(City city) async {
  final response = await requests.requestTowns(city.centerId);
  final towns = parsers.parseTowns(response);
  log("Got towns $towns", name: "Backend");
  return towns;
}

Future<void> cancelWorkers() async {
  await worker.cancelWorks();
  log("Worker cancel", name: "Backend");
}
