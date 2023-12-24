import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:meteo_uyari/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/alert.dart';

MaterialPageRoute<void> alertDetailsView(Alert alert) {
  final cityCodes = {for (final town in alert.towns) town.formattedCityCode};
  //Simple Map plugin needs to formatted city codes like this
  final mapColors = <String, Color>{
    for (final cityCode in cityCodes) "TR-$cityCode": alert.color
  };
  return MaterialPageRoute(
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(alert.hadise.baslik),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                alert.description,
                style: const MyTextStyles.medium(),
              ),
              Divider(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              Text(
                "Başlangıç ${alert.beginTime.formattedHour}:${alert.beginTime.formattedMinute}\nBitiş ${alert.endTime.formattedHour}:${alert.endTime.formattedMinute}",
                style: const MyTextStyles.small(),
              ),
              Divider(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.1),
                child: SimpleMap(
                  instructions: SMapTurkey.instructions,
                  colors: mapColors,
                ),
              ),
              Divider(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.1),
                child: ElevatedButton(
                    //Example url: www.mgm.gov.tr/Meteouyari/il.aspx?id=93301&Gun=1
                    onPressed: () => launchUrl(Uri.https(
                        "www.mgm.gov.tr",
                        "/Meteouyari/il.aspx",
                        {"id": alert.towns.first.id.toString(), "gun": "1"})),
                    child: const Text("Detaylar")),
              )
            ],
          ),
        ),
      );
    },
  );
}
