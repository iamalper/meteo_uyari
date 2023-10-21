import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:meteo_uyari/screens/add_city.dart';
import '../classes/firestore.dart';
import '../classes/messagging.dart';
import '../view_models/warning_containter.dart';
import 'alerts_page.dart';

class MainScreen extends StatefulWidget {
  ///It should not be empty list
  final List<City> savedCities;
  const MainScreen({super.key, required this.savedCities});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final cities = widget.savedCities;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            tooltip: "Şehir ekle",
            onPressed: () async {
              final addedCity = await Navigator.push<City>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCityPage(),
                  ));
              if (addedCity != null) {
                setState(() {
                  cities.add(addedCity);
                });
              }
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title:
                const Text(kDebugMode ? "Meteo Uyarı (debug)" : "Meteo Uyarı"),
            actions: [
              IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh",
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(10),
                child: FutureBuilder(
                  future: isPermissionGranted,
                  builder: (context, snapshot) {
                    if (snapshot.data == false) {
                      return warningContainer(
                          "Bildirimler devre dışı.", "Bildirimleri etkinleştir",
                          () async {
                        if (await getPermission()) {
                          setState(() {});
                        }
                      });
                    } else {
                      return const SizedBox(
                        height: 1.00,
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: FutureBuilder(
                        future: getAlerts(widget.savedCities),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              final error = snapshot.error;
                              if (error is MeteoUyariException) {
                                return Center(child: Text(error.message));
                              } else if (error != null) {
                                throw error;
                              } else {
                                final data = snapshot.data!;
                                return PageView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: cities.length,
                                  itemBuilder: (context, index) => AlertsPage(
                                      alerts: data
                                          .where((element) => element.towns
                                              .contains(
                                                  cities[index].centerIdInt))
                                          .toList(),
                                      cityName: cities[index].name),
                                );
                              }
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator());
                            default:
                              throw Error();
                          }
                        })),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Veriler mgm.gov.tr adresinden alınmaktadır."),
              )
            ],
          ),
        );
      }),
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
