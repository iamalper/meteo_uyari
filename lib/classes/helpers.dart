import 'dart:developer';
import 'messagging.dart' as messaging;
import '../models/city.dart';
import 'package:localstore/localstore.dart';

final _db = Localstore.instance;
final _savedCitiesCollection = _db.collection("savedCities");

///Save the city and setup push notifications.
///
///If called for same [city] multiple times, it has no effect.
///
///Returns [false] if notification permission denied by user.
Future<bool> setNotificationForNewCity(City city) async {
  final result = await messaging.setup(city);
  if (result) {
    await _savedCitiesCollection.doc(city.centerId).set(city.toMap);
    log("Notifications set for: $city", name: "Helpers");
  } else {
    log("Notification permission denied.", name: "Helpers");
  }
  return result;
}

///Get all saved [City] objects with [Localstore]
///
///Returns empty [List] if no city saved with [setNotificationForNewCity()]
Future<List<City>> getSavedCities() async {
  final citiesMap = await _savedCitiesCollection.get();
  return citiesMap?.values.map((e) => City.fromMap(e)).toList() ?? [];
}

///Deletes previously saved [city] and unsubscribes from [city] notifications
Future<void> deleteCity(City city) async {
  await Future.wait([
    _savedCitiesCollection.doc(city.centerId).delete(),
    messaging.unsubscribeFromCity(city)
  ]);
  log("$city removed", name: "Helpers");
}
