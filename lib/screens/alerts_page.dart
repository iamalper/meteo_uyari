import 'package:flutter/material.dart';
import 'package:meteo_uyari/themes.dart';
import '../models/alert.dart';

class AlertsPage extends StatefulWidget {
  ///[alerts] are shown to user.
  ///
  ///It's safe to pass empty list.
  final List<Alert> alerts;

  ///[cityName] is shown to user.
  final String cityName;

  ///Page for listing alerts for a single city.
  const AlertsPage({super.key, required this.alerts, required this.cityName});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${widget.cityName} için hava durumu uyarıları",
          style: const MyTextStyles.big(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: widget.alerts.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/screen_icons/safe-weather.png"),
                      const Text(
                        "Herhangi bir uyarı yok",
                        style: MyTextStyles.medium(),
                      ),
                    ],
                  )
                : ListView.separated(
                    itemBuilder: (context, index) =>
                        widget.alerts[index].listTile,
                    separatorBuilder: (context, index) => const Divider(
                          height: 5,
                        ),
                    itemCount: widget.alerts.length),
          ),
        ),
      ],
    );
  }
}
