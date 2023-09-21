import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/database.dart' as database;
import 'package:meteo_uyari/screens/main_screen.dart';
import 'screens/intro/page_controller.dart';

Future<void> main() async {
  final savedCity = await database.getCity();
  runApp(savedCity == null ? const Intro() : MainScreen(savedCity: savedCity));
}
