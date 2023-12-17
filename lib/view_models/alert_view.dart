import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/themes.dart';
import 'package:intl/intl.dart' show NumberFormat;

final _timeIntFormat = NumberFormat("00");
ListTile alertListTile(Alert alert) => ListTile(
      leading: Image.asset("assets/alert_icons/${alert.hadise.name}.png"),
      title: Text(
        alert.hadise.baslik,
        style: const MyTextStyles.medium(),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            alert.description,
            style: const MyTextStyles.small(),
          ),
          Text(
            "Başlangıç: ${_timeIntFormat.format(alert.beginTime.hour)}:${_timeIntFormat.format(alert.beginTime.minute)} Bitiş: ${_timeIntFormat.format(alert.endTime.hour)}:${_timeIntFormat.format(alert.endTime.minute)}",
            style: const MyTextStyles.small().copyWith(color: Colors.blue),
          )
        ],
      ),
      tileColor: alert.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
