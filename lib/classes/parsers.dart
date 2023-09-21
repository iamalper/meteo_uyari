import 'dart:convert' show jsonDecode;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:meteo_uyari/classes/exceptions.dart';
import '../models/city.dart';
import '../models/alert.dart';
import '../models/town.dart';

List<City> parseCities(String body) {
  final document = parse(body);
  final element = document.getElementById("turkiye");
  if (element == null) throw ParserException();
  final elements = element.children;
  List<City> cities = [];
  for (var element in elements) {
    final iladiRaw = element.attributes["data-iladi"];
    if (iladiRaw == null) throw ParserException();

    cities.add(City(name: iladiRaw, centerId: int.parse(element.id)));
  }
  log("Cities parsed", name: "Parsers");
  return cities;
}

List<Alert> parseAlerts(String body, int id) {
  final List<dynamic> bodyJson = jsonDecode(body);
  List<Alert> alerts = [];
  for (Map element in bodyJson) {
    final Map? towns = element["towns"];
    if (towns == null) continue;
    final yellowTownIds = towns["yellow"] as List;
    final orangeTownIds = towns["orange"] as List;
    final redTownIds = towns["red"] as List;

    final beginTime = DateTime.parse(element["begin"]);
    final endTime = DateTime.parse(element["end"]);
    final alertNo = element["alertNo"].toString();
    final String description = (element["text"] as Map).values.first;

    final Color color;
    if (redTownIds.contains(id)) {
      color = Colors.red;
    } else if (orangeTownIds.contains(id)) {
      color = Colors.orange;
    } else if (yellowTownIds.contains(id)) {
      color = Colors.yellow;
    } else {
      continue;
    }
    alerts.add(Alert(
        description: description,
        color: color,
        beginTime: beginTime,
        endTime: endTime,
        alertNo: alertNo));
  }
  log("Alerts parsed for id: $id, result: $alerts", name: "Parsers");
  return alerts;
}

List<Town> parseTowns(String body) {
  List<Town> towns = [];
  final document = parse(body, encoding: "tr");
  final paths = document.getElementsByTagName("path");
  for (var path in paths) {
    final nameRaw = path.attributes["name"];
    if (nameRaw == null) throw ParserException();
    final idString = path.attributes["id"];
    if (idString == null) continue;
    final id = int.parse(idString);
    towns.add(Town(id: id, name: nameRaw));
  }
  log("Towns parsed, result: $towns", name: "Parsers");
  return towns;
}
