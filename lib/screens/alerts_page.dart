import 'package:flutter/material.dart';
import '../models/alert.dart';

class AlertsPage extends StatelessWidget {
  final List<Alert> alerts;
  final String cityName;
  const AlertsPage({super.key, required this.alerts, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$cityName için hava durumu uyarıları"),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.separated(
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
