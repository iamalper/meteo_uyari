import 'dart:developer';
import 'messagging.dart' as messaging;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';

///Saves [city],and registers pusn notifications for [city]
///
///Returns [false] if notification permission can't granted.
Future<bool> setNotifications(City city) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setString("savedCityId", city.centerId);
  await sp.setString("savedCityName", city.name);
  final result = await messaging.setup(city);
  if (result) {
    log("Notifications set for: $city", name: "Backend");
  } else {
    log("Notification permission denied.", name: "Backend");
  }
  return result;
}

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
