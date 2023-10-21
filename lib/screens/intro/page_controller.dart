import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/helpers.dart' as helpers;
import 'package:meteo_uyari/main.dart';
import 'warnings.dart';
import '../../models/city.dart';
import 'select_location.dart';
import 'alerts_intro.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final _controller = PageController();
  void _gotoPage(int index) => _controller.animateToPage(index,
      duration: const Duration(milliseconds: 200), curve: Curves.linear);
  City? _city;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  minimumSize: const MaterialStatePropertyAll(Size(100, 50)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))))),
      theme: ThemeData.light().copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  minimumSize: const MaterialStatePropertyAll(Size(100, 50)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))))),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SelectLocation(
                  onLocationSet: (city) {
                    _city = city;
                    _gotoPage(1);
                  },
                ),
                AlertsIntro(
                  onContiune: () => _gotoPage(2),
                ),
                Warnings(
                  onContiune: () async {
                    await helpers.setNotificationForNewCity(_city!);
                    await main();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
