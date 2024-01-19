import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/town.dart';
import 'package:meteo_uyari/view_models/alert_details_view.dart';
import '../view_models/alert_view.dart';
import 'city.dart';
import 'formatted_datetime.dart';
import 'dart:convert';

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
        severity = Severity.values.singleWhere(
          (element) => element.name == map["severity"],
        ),
        hadise = Hadise.values.singleWhere((element) =>
            element.name == map["hadise"] || element.baslik == map["hadise"]),
        description = map["description"],
        towns = switch (map["town"]) {
          //For Firebase Cloud Messaging data payload, it is String because of limitation
          String towns => {
              for (final town in towns.split(","))
                Town.fromMap(jsonDecode(town))
            },
          List<Map<String, dynamic>> towns => {
              for (final map in towns) Town.fromMap(map)
            },
          null => {},
          _ => throw Error()
        },
        beginTime = switch (map["begin_time"]) {
          int beginTime =>
            FormattedDateTime.fromMillisecondsSinceEpoch(beginTime),
          String beginTime =>
            FormattedDateTime.fromMillisecondsSinceEpoch(int.parse(beginTime)),
          _ => throw Error()
        },
        endTime = switch (map["end_time"]) {
          int endTime => FormattedDateTime.fromMillisecondsSinceEpoch(endTime),
          String endTime =>
            FormattedDateTime.fromMillisecondsSinceEpoch(int.parse(endTime)),
          _ => throw Error()
        };

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

  ///Page route for pushing [alertDetailsView] to screen
  ///
  ///Example:
  ///```dart
  ///Navigator.of(context).push(alert.detailsPageRoute)
  ///```
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
