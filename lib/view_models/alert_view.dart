import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/themes.dart';

import '../classes/assets.dart';

class AlertBoxView extends StatelessWidget {
  final Alert alert;
  const AlertBoxView(
    this.alert, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getHadiseImage(alert.hadise, foregroundColor: Colors.white),
      title: Text(
        alert.hadise.baslik,
        style: const MyTextStyles.medium(),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            alert.description,
            style: const MyTextStyles.small(),
          ),
          Text(
            "Başlangıç: ${alert.beginTime.formattedHour}:${alert.beginTime.formattedMinute} Bitiş: ${alert.endTime.formattedHour}:${alert.endTime.formattedMinute}",
            style: const MyTextStyles.small().copyWith(color: Colors.blue),
          )
        ],
      ),
      tileColor: alert.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onTap: () => Navigator.of(context).push(alert.detailsPageRoute),
    );
  }
}
