import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/classes/helpers.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:meteo_uyari/screens/add_city.dart';
import 'package:meteo_uyari/screens/alerts_page_view.dart';
import 'package:meteo_uyari/screens/debug_info_page.dart';
import '../classes/messagging.dart';
import '../classes/supabase.dart';
import '../models/alert.dart';
import '../models/formatted_datetime.dart';
import '../models/town.dart';
import '../view_models/warning_containter.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../themes.dart' as my_themes;

class MainScreen extends StatefulWidget {
  ///It should not be empty list
  final List<City> savedCities;
  const MainScreen({super.key, required this.savedCities});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final _cities = widget.savedCities;
  final _pageController = PageController();
  late var _tabController = TabController(length: _cities.length, vsync: this);
  var devMode = false;
  final _fabKey = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      themeMode:
          ThemeMode.light, //FIXME: Dark theme has issues with alert view.
      theme: my_themes.myLightTheme,
      darkTheme: my_themes.myDarkTheme,
      home: Builder(
          builder: (context) => Scaffold(
                floatingActionButtonLocation: ExpandableFab.location,
                floatingActionButton: ExpandableFab(key: _fabKey, children: [
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
                        if (index != null && _cities.length > index) {
                          _onRemoveCityButtonPressed(context, _cities[index]);
                        }
                      }),
                  FloatingActionButton.small(
                      heroTag: null,
                      tooltip: "Geliştirici Modu",
                      child: const Icon(Icons.developer_mode),
                      onPressed: () {
                        setState(() {
                          devMode = !devMode;
                        });
                        _fabKey.currentState?.toggle();
                      }),
                ]),
                appBar: AppBar(
                  title: const Text(
                      kDebugMode ? "Meteo Uyarı (debug)" : "Meteo Uyarı"),
                  actions: [
                    IconButton(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh),
                      tooltip: "Refresh",
                    ),
                    if (devMode)
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const DebugInfoPage())),
                        icon: const Icon(Icons.developer_mode),
                        tooltip: "Debug",
                      )
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: _cities
                        .map((e) => Tab(
                              text: e.name,
                            ))
                        .toList(),
                    onTap: (value) => _pageController.animateToPage(value,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear),
                  ),
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.all(10),
                      child: FutureBuilder(
                        future: isPermissionGranted(),
                        builder: (context, snapshot) {
                          if (snapshot.data == false) {
                            //Android does not require permission and firebase does not initalize for desktop
                            return warningContainer("Bildirimler devre dışı.",
                                "Bildirimleri etkinleştir", () async {
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
                              future: devMode
                                  ? Future.value(_demoAlerts)
                                  : getAlerts(widget.savedCities),
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
                                      return AlertsPageView(
                                        pageController: _pageController,
                                        cities: _cities,
                                        data: data.toList(),
                                        tabController: _tabController,
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
                      child:
                          Text("Veriler mgm.gov.tr adresinden alınmaktadır."),
                    )
                  ],
                ),
              )),
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
        //TODO: find better way from reinitalising tabController
        _tabController = TabController(
            length: _cities.length,
            vsync: this,
            animationDuration: const Duration(milliseconds: 100));
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
        //TODO: find better way from reinitalising tabController
        _tabController = TabController(length: _cities.length, vsync: this);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
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

String _cityCodeFormat(int cityCode) {
  final formatter = NumberFormat("00");
  return formatter.format(cityCode);
}

final _demoAlerts = [
  Alert(
      no: "230134",
      severity: Severity.orange,
      hadise: Hadise.hot,
      description: "deneme deneme",
      towns: {
        for (var i = 1; i < 81; i++)
          Town(id: int.parse("9${_cityCodeFormat(i)}01"))
      },
      beginTime: FormattedDateTime.now(),
      endTime: FormattedDateTime.now()),
  Alert(
      no: "230134",
      severity: Severity.red,
      hadise: Hadise.wind,
      description: "deneme deneme 123 123",
      towns: {
        for (var i = 1; i < 81; i++)
          Town(id: int.parse("9${_cityCodeFormat(i)}01"))
      },
      beginTime: FormattedDateTime.now(),
      endTime: FormattedDateTime.now())
];
