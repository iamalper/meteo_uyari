import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meteo_uyari/classes/helpers.dart' as helpers;
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:optimization_battery/optimization_battery.dart';
import 'package:autostarter/autostarter.dart';

import '../view_models/warning_containter.dart';

class MainScreen extends StatefulWidget {
  final City savedCity;
  const MainScreen({super.key, required this.savedCity});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _uiTest = kDebugMode;
  final _title = kDebugMode ? "Meteo Uyarı (debug)" : "Meteo Uyarı";
  Future<bool> autoStarterState() async {
    try {
      return await Autostarter.checkAutoStartState() ?? true;
    } on MissingPluginException catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: [
            IconButton(
              onPressed: testButtonOnPressed,
              icon: const Icon(Icons.tag_faces),
              tooltip: "Test mode",
            ),
            IconButton(
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
              tooltip: "Refresh",
            )
          ],
        ),
        body: Column(
          children: [
            BatteryOptimizationsObserver(
              builder: (p0, isIgnored) {
                isIgnored ??= true;
                if (isIgnored) {
                  return const Divider(
                    height: 10,
                  );
                } else {
                  return warningContainer(
                      "Cihazınızın pil optimizasyonu aktif\nPil optimizasyonu açıkken bildirimler gelmeyebilir.",
                      "Devre dışı bırakın",
                      OptimizationBattery.openBatteryOptimizationSettings);
                }
              },
            ),
            FutureBuilder(
              future: autoStarterState(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Divider(
                      height: 10,
                    );
                  case ConnectionState.done:
                    final error = snapshot.error;
                    if (error != null) {
                      throw error;
                    } else {
                      final isAutoStartEnabled = snapshot.data!;
                      if (isAutoStartEnabled) {
                        return const Divider(
                          height: 10,
                        );
                      } else {
                        return warningContainer(
                            "MIUI pil optimizasyonu aktif\nMIUI optimizasyonu açıkken bildirimler gelmeyebilir.",
                            "Devre dışı bırakın",
                            Autostarter.getAutoStartPermission);
                      }
                    }
                  default:
                    throw Error();
                }
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(10),
                child: FutureBuilder(
                    future: helpers.getAlerts(widget.savedCity.centerId,
                        uiTest: _uiTest),
                    builder: ((context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          final error = snapshot.error;
                          if (error is MeteoUyariException) {
                            return Center(child: Text(error.message));
                          } else if (error != null) {
                            throw error;
                          } else {
                            return ListView.separated(
                                itemBuilder: ((context, index) {
                                  final alert = snapshot.data![index];
                                  return alert.listTile;
                                }),
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      height: 5,
                                    ),
                                itemCount: snapshot.data!.length);
                          }
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          throw Error();
                      }
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void testButtonOnPressed() {
    setState(() {
      _uiTest = !_uiTest;
    });
  }
}
