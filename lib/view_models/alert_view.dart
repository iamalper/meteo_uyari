import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/themes.dart';

ListTile alertListTile(Alert alert) => ListTile(
    leading: Image.asset("assets/alert_icons/${alert.hadise.name}.png"),
    title: Text(
      alert.hadise.baslik,
      style: const MyTextStyles.medium(),
    ),
    subtitle: Text(
      alert.description,
      style: const MyTextStyles.small(),
    ),
    tileColor: alert.color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
