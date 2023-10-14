import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';

ListTile alertListTile(Alert alert) => ListTile(
    title: Text(alert.no),
    subtitle: Text(alert.description),
    tileColor: alert.color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
