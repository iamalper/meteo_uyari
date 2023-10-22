import 'package:flutter/material.dart';
import '../models/alert.dart';

class AlertsPage extends StatelessWidget {
  ///[alerts] are shown to user.
  ///
  ///It's safe to pass empty list.
  final List<Alert> alerts;

  ///[cityName] is shown to user.
  final String cityName;

  ///Page for listing alerts for a single city.
  const AlertsPage({super.key, required this.alerts, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$cityName için hava durumu uyarıları"),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: alerts.isEmpty
                ? const Center(child: Text("Herhangi bir uyarı yok"))
                : ListView.separated(
                    itemBuilder: ((context, index) {
                      final alert = alerts[index];
                      return alert.listTile;
                    }),
                    separatorBuilder: (context, index) => const Divider(
                          height: 5,
                        ),
                    itemCount: alerts.length),
          ),
        ),
      ],
    );
  }
}
