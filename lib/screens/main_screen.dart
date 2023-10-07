import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/exceptions.dart';
import 'package:meteo_uyari/models/city.dart';
import '../classes/firestore.dart';
import '../classes/messagging.dart';
import '../view_models/warning_containter.dart';

class MainScreen extends StatefulWidget {
  final City savedCity;
  const MainScreen({super.key, required this.savedCity});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      future: getAlerts(int.parse(widget.savedCity.centerId)),
                      builder: (context, snapshot) {
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
          ],
        ),
      ),
    );
  }
}
