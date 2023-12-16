import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  try {
    await Supabase.initialize(
        url: "https://srdtccwudnoamyjhkojo.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNyZHRjY3d1ZG5vYW15amhrb2pvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkxNzkwNjksImV4cCI6MjAxNDc1NTA2OX0.2PV-c8i0UgDqxzc-jQKHXWXj-cUIaz-MmKjp6dl78uQ");
  } on AssertionError catch (_) {
    //Exception throws if supabase initalized more than one
  }
  final savedCities = await getSavedCities();
  log("Loaded cities: $savedCities");
  runApp(savedCities.isEmpty
      ? const Intro()
      : MainScreen(savedCities: savedCities));
}
