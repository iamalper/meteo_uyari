import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';

ListTile alertListTile(Alert alert) => ListTile(
    leading: Image.asset("assets/alert_icons/${alert.hadise.name}.png"),
    title: Text(alert.hadise.baslik),
    subtitle: Text(alert.description),
    tileColor: alert.color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
