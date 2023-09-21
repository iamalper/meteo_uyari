import 'package:flutter/material.dart';
import 'package:meteo_uyari/view_models/alert_view.dart';

class Alert {
  final String description;

  ///Red, orange or yellow.
  final Color color;
  final DateTime beginTime;
  final DateTime endTime;

  ///Unique for all alerts.
  final String alertNo;
  const Alert(
      {required this.description,
      required this.color,
      required this.beginTime,
      required this.endTime,
      required this.alertNo});

  @override
  int get hashCode => alertNo.hashCode;

  ListTile get listTile => alertListTile(this);

  @override
  String toString() =>
      "Description: $description, Color: $color, beginTime: $beginTime, endTime: $endTime, alertNo: $alertNo";

  @override
  bool operator ==(Object other) {
    if (other is Alert) {
      return other.hashCode == hashCode;
    } else {
      return false;
    }
  }
}
