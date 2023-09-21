import 'package:flutter/material.dart';
import '../models/alert.dart';

class AlertListTile extends ListTile {
  final Alert alert;
  AlertListTile(this.alert, {super.key})
      : super(
            title: Text(alert.alertNo),
            subtitle: Text(alert.description),
            tileColor: alert.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)));
}
