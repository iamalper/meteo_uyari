import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/supabase.dart' as supabase;
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'classes/helpers.dart' as helpers;
import 'screens/intro/page_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } on UnsupportedError catch (_) {}
  await supabase.initSupabase();
  final savedTowns = await helpers.getSavedTowns();
  log("Loaded cities: $savedTowns");
  await helpers.setNotificationChannel(
      "weatherAlerts", "Hava Durumu Uyarıları");
  if (savedTowns.isEmpty) {
    runApp(const Intro());
  } else {
    runApp(MainScreen(savedTowns: savedTowns));
  }
}
