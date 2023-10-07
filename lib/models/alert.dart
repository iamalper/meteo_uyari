import 'package:flutter/material.dart';
import 'package:meteo_uyari/view_models/alert_view.dart';

enum Hadise {
  cold,
  hot,
  fog,
  agricultural,
  ice,
  dust,
  snowmelt,
  avalanche,
  snow,
  thunderstorm,
  wind,
  rain
}

enum Severity { yellow, orange, red }

class Alert {
  ///Unique for all alerts.
  final String no;

  final Severity severity;
  final Hadise hadise;
  final String description;
  final List<String> towns;
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
        towns = map["towns"],
        beginTime = DateTime.fromMillisecondsSinceEpoch(map["beginTime"]),
        endTime = DateTime.fromMillisecondsSinceEpoch(map["endTime"]);

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
