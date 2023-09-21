import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactory, databaseFactoryFfiNoIsolate, sqfliteFfiInit;
import 'package:sqflite/sqflite.dart';

Database? _db;
SharedPreferences? _prefs;
const _alertTable = "Alerts";
const _alertCodeColumn = "AlertCode";

///Set up database.
///
///It is automatically called when trying to do database operation before
///starting database.
Future<void> start() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prefs = await SharedPreferences.getInstance();
  if (Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  }
  _db = await openDatabase('alerts.db',
      onCreate: (db, version) => db.execute(
          "CREATE TABLE $_alertTable (id INTEGER PRIMARY KEY, $_alertCodeColumn TEXT NOT NULL)"),
      version: 1);
  log("Initalised", name: "Database");
}

Future<City?> getCity() async {
  if (_prefs == null) await start();
  final id = _prefs!.getInt("cityId");
  final name = _prefs!.getString("cityName");
  if (id == null || name == null) return null;
  final city = City(name: name, centerId: id);
  log("Got saved city: $city", name: "Database");
  return city;
}

///set [city] to [null] for removing saved city.
Future<void> saveCity(City? city) async {
  final Future<bool> setIdFuture;
  final Future<bool> setNameFuture;
  if (_prefs == null) await start();
  if (city == null) {
    setIdFuture = _prefs!.remove("cityId");
    setNameFuture = _prefs!.remove("cityName");
    log("City removed", name: "Database");
  } else {
    setIdFuture = _prefs!.setInt("cityId", city.centerId);
    setNameFuture = _prefs!.setString("cityName", city.name);
    log("City saved: $city", name: "Database");
  }
  final result = await Future.wait([setIdFuture, setNameFuture]);
  if (result.contains(false)) throw UnableToSaveCityException();
}

///İnsert an alert code to database for preventing repeated notifications.
///
///Each time an alert received, its checked by background worker with [checkAlertIsNew].
///If not exists in database, alert notification shown to user.
Future<void> insertAlert(String alertCode) async {
  if (_db == null) await start();
  await _db!.insert(_alertTable, {_alertCodeColumn: alertCode});
  log("New alert code insert $alertCode", name: "Database");
}

///Checks if not [alertCode]saved to database with [insertAlert] before.
Future<bool> checkAlertIsNew(String alertCode) async {
  if (_db == null) await start();
  final result = await _db!.query(_alertTable,
      where: "$_alertCodeColumn=?", limit: 1, whereArgs: [alertCode]);
  final isNew = result.isEmpty;
  log("Is Alert $alertCode new: $isNew", name: "Database");
  return isNew;
}

Future<void> clearAlerts() async {
  if (_db == null) await start();
  await _db!.delete(_alertTable);
  log("All Alerts removed", name: "Database");
}

Future<void> closeDb() async {
  await _db?.close();
  log("Closed", name: "Database");
}
