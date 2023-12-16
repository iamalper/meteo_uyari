import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'classes/helpers.dart';
import 'screens/intro/page_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } on UnsupportedError catch (_) {}
  await initSupabase();
  final savedCities = await getSavedCities();
  log("Loaded cities: $savedCities");
  runApp(savedCities.isEmpty
      ? const Intro()
      : MainScreen(savedCities: savedCities));
}
