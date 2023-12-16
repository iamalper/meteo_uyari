import 'package:flutter/material.dart';
import '../view_models/alert_view.dart';
import 'city.dart';

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

  ///The Town ids which affected for [Alert]
  ///
  ///They can be comperated with [City.centerIdInt]
  final List<int> towns;
  final DateTime beginTime;
  final DateTime endTime;

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
        towns = (map["towns"] as List).cast<int>(),
        beginTime = DateTime.fromMillisecondsSinceEpoch(map["begin_time"]),
        endTime = DateTime.fromMillisecondsSinceEpoch(map["end_time"]);

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
        "severity": severity.toString(),
        "hadise": hadise.toString(),
        "description": description,
        "towns": towns,
        "beginTime": beginTime.millisecondsSinceEpoch,
        "endTime": endTime.millisecondsSinceEpoch
      };

  @override
  int get hashCode => no.hashCode;

  ListTile get listTile => alertListTile(this);

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
