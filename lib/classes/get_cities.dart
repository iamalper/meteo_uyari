import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/models/city.dart';

///Get list of [City]'s available from MeteoUyarı api
Future<List<City>> getCities() async {
  final response = await Supabase.instance.client.functions
      .invoke("get_cities", method: HttpMethod.get);
  if (response.status != 200) {
    log("Cities status code ${response.status}");
    throw const NetworkException();
  }
  final json = response.data as List<dynamic>;
  final cities = json.map((e) => City.fromMap(e)).toList();
  return cities;
}
