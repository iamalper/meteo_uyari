import 'dart:developer';
import 'messagging.dart' as messaging;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import 'package:localstore/localstore.dart';

final _db = Localstore.instance;
final _savedCitiesCollection = _db.collection("savedCities");

///Saves **single** [city],if exists overwrites [city] ,and registers push notifications for [city]
///
///Returns [false] if notification permission can't granted.
@Deprecated("Use setNotificationForNewCity() instead")
Future<bool> setNotifications(City city) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setString("savedCityId", city.centerId);
  await sp.setString("savedCityName", city.name);
  final result = await messaging.setup(city);
  if (result) {
    log("Notifications set for: $city", name: "Helpers");
  } else {
    log("Notification permission denied.", name: "Helpers");
  }
  return result;
}

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

///Get **single** saved city with [SharedPreferences]
@Deprecated("Use getSavedCities() instead")
Future<City?> getSavedCity() async {
  final sp = await SharedPreferences.getInstance();
  final cityId = sp.getString("savedCityId");
  final cityName = sp.getString("savedCityName");
  if (cityName == null || cityId == null) {
    return null;
  } else {
    final savedCity = City(centerId: cityId, name: cityName);
    return savedCity;
  }
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
