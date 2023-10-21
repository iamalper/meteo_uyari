import 'package:flutter/foundation.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Şehir ekle",
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCityPage(),
              )),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text(kDebugMode ? "Meteo Uyarı (debug)" : "Meteo Uyarı"),
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
                            final data = snapshot.data;
                            if (error is MeteoUyariException) {
                              return Center(child: Text(error.message));
                            } else if (error != null) {
                              throw error;
                            } else {
                              final cities = widget.savedCities;
                              return PageView.builder(
                                itemCount: cities.length,
                                itemBuilder: (context, index) => AlertsPage(
                                    alerts: data!
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
      ),
    );
  }
}
