import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/classes/helpers.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:meteo_uyari/screens/add_city.dart';
import '../classes/firestore.dart';
import '../classes/messagging.dart';
import '../view_models/warning_containter.dart';
import 'alerts_page.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class MainScreen extends StatefulWidget {
  ///It should not be empty list
  final List<City> savedCities;
  const MainScreen({super.key, required this.savedCities});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final _cities = widget.savedCities;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(children: [
            FloatingActionButton.small(
              heroTag: null,
              tooltip: "Şehir ekle",
              child: const Icon(Icons.add),
              onPressed: () => _onAddCityButtonPressed(context),
            ),
            FloatingActionButton.small(
                heroTag: null,
                tooltip: "Şehiri sil",
                child: const Icon(Icons.delete),
                onPressed: () {
                  final index = _pageController.page?.toInt();
                  if (index != null) {
                    _onRemoveCityButtonPressed(context, _cities[index]);
                  }
                })
          ]),
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
                                  controller: _pageController,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _cities.length,
                                  itemBuilder: (context, index) => AlertsPage(
                                      alerts: data
                                          .where((element) => element.towns
                                              .contains(
                                                  _cities[index].centerIdInt))
                                          .toList(),
                                      cityName: _cities[index].name),
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

  Future<void> _onAddCityButtonPressed(BuildContext context) async {
    final addedCity = await Navigator.push<City>(
        context,
        MaterialPageRoute(
          builder: (context) => const AddCityPage(),
        ));
    if (addedCity != null) {
      setState(() {
        _cities.add(addedCity);
      });
    }
  }

  Future<void> _onRemoveCityButtonPressed(
      BuildContext context, City city) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${city.name} şehrini silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Evet")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Hayır"))
        ],
      ),
    );
    if (result ?? false) {
      await deleteCity(city);
      setState(() {
        _cities.remove(city);
      });
    }
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
