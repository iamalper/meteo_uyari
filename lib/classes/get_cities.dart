import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/models/city.dart';

final _uri = Uri.https("europe-west1-meteouyari.cloudfunctions.net", "/cities");
Future<List<City>> getCities() async {
  final result = await http.get(_uri);
  if (result.statusCode != 200) {
    throw const NetworkException();
  }
  final json = jsonDecode(result.body) as List<dynamic>;
  final cities = json.map((e) => City.fromMap(e)).toList();
  return cities;
}
