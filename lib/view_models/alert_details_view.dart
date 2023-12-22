import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:meteo_uyari/themes.dart';
import '../models/alert.dart';

MaterialPageRoute<void> alertDetailsView(Alert alert) {
  final cityCodes = {
    for (final town in alert.towns) town.toString().substring(1, 3)
  };
  assert(cityCodes.every((cityCode) {
    final code = int.parse(cityCode);
    return code >= 0 && code <= 81;
  }));
  final mapColors = <String, Color>{
    for (final cityCode in cityCodes) "TR-$cityCode": alert.color
  };
  return MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text(alert.hadise.baslik),
      ),
      body: ListView(
        children: [
          Text(
            alert.description,
            style: const MyTextStyles.medium(),
          ),
          const Divider(),
          Text(
            "Başlangıç ${alert.beginTime.formattedHour}:${alert.beginTime.formattedMinute}\nBitiş ${alert.endTime.formattedHour}:${alert.endTime.formattedMinute}",
            style: const MyTextStyles.small(),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.2),
            child: SimpleMap(
              instructions: SMapTurkey.instructions,
              colors: mapColors,
            ),
          ),
        ],
      ),
    ),
  );
}
