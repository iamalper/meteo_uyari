import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/helpers.dart' as helpers;
import 'package:meteo_uyari/main.dart';
import 'package:meteo_uyari/models/town.dart';
import 'warnings.dart';
import 'select_location.dart';
import 'alerts_intro.dart';
import '../../themes.dart' as my_themes;

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final _controller = PageController();
  void _gotoPage(int index) => _controller.animateToPage(index,
      duration: const Duration(milliseconds: 200), curve: Curves.linear);
  Town? _town;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: my_themes.myDarkTheme,
      theme: my_themes.myLightTheme,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SelectLocation(
                  onLocationSet: (town) {
                    _town = town;
                    _gotoPage(1);
                  },
                ),
                AlertsIntro(
                  onContinue: () => _gotoPage(2),
                ),
                Warnings(
                  onContinue: () async {
                    await helpers.setNotificationForNewTown(_town!);
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
