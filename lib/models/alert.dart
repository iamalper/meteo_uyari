import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/town.dart';
import 'package:meteo_uyari/view_models/alert_details_view.dart';
import '../view_models/alert_view.dart';
import 'city.dart';
import 'formatted_datetime.dart';

enum Hadise {
  cold("Soğuk"),
  hot("Sıcak"),
  fog("Sis"),
  agricultural("Zirai don"),
  ice("Buzlanma ve Don"),
  dust("Toz Taşınımı"),
  snowmelt("Kar Erimesi"),
  avalanche("Çığ"),
  snow("Kar"),
  thunderstorm("Gökgürültülü Sağanak Yağış"),
  wind("Rüzgar"),
  rain("Yağmur");

  const Hadise(this.baslik);
  final String baslik;
}

enum Severity { yellow, orange, red }

class Alert {
  ///Unique for all alerts.
  final String no;

  final Severity severity;
  final Hadise hadise;

  ///Turkish, latin5 encoded description for [Alert]
  final String description;

  ///The [Town]'s which affected for [Alert]
  ///
  ///[Town.id] can be comperated with [City.centerIdInt]
  final Set<Town> towns;
  final FormattedDateTime beginTime;
  final FormattedDateTime endTime;

  const Alert({
    required this.no,
    required this.severity,
    required this.hadise,
    required this.description,
    required this.towns,
    required this.beginTime,
    required this.endTime,
  });

  Alert.fromMap(Map<String, dynamic> map)
      : no = map["no"],
        severity = Severity.values
            .singleWhere((element) => element.name == map["severity"]),
        hadise = Hadise.values
            .singleWhere((element) => element.name == map["hadise"]),
        description = map["description"],
        towns = {for (final townId in map["towns"]) Town(id: townId)},
        beginTime =
            FormattedDateTime.fromMillisecondsSinceEpoch(map["begin_time"]),
        endTime = FormattedDateTime.fromMillisecondsSinceEpoch(map["end_time"]);

  Color get color {
    switch (severity) {
      case Severity.yellow:
        return Colors.yellow;
      case Severity.orange:
        return Colors.orange;
      case Severity.red:
        return Colors.red;
    }
  }

  Map<String, dynamic> get toMap => {
        "no": no,
        "severity": severity.name,
        "hadise": hadise.name,
        "description": description,
        "towns": {for (final town in towns) town.id},
        "beginTime": beginTime.millisecondsSinceEpoch,
        "endTime": endTime.millisecondsSinceEpoch
      };

  MaterialPageRoute<void> get detailsPageRoute => alertDetailsView(this);

  @override
  int get hashCode => no.hashCode;

  StatelessWidget get alertBoxTile => AlertBoxView(this);

  @override
  String toString() =>
      "Description: $description, Color: $color, beginTime: $beginTime, endTime: $endTime, alertNo: $no";

  @override
  bool operator ==(Object other) {
    if (other is Alert) {
      return other.hashCode == hashCode;
    } else {
      return false;
    }
  }
}
