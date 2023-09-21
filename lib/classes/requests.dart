import 'dart:developer';
import 'package:convert/convert.dart' show latin5;
import 'package:http/http.dart' as http;

const _headers = {
  "Host": "www.mgm.gov.tr",
  "Origin": "https://www.mgm.gov.tr",
  "Referer": "https://www.mgm.gov.tr/",
};

Future<String> requestCities() async {
  final url =
      Uri.https("www.mgm.gov.tr", "Meteouyari/Turkiye.aspx", {"Gun": "1"});
  final response = await http.get(url, headers: _headers);
  log("Cities requested", name: "Requests");
  return response.body;
}

Future<String> requestAlerts() async {
  final url = Uri.https("servis.mgm.gov.tr", "web/meteoalarm/today");
  final response = await http.get(url, headers: _headers);
  log("Alerts requested", name: "Requests");
  return response.body;
}

Future<String> requestTowns(int centerId) async {
  final url =
      Uri.https("www.mgm.gov.tr", "meteouyari/Scripts/Map/SVG/$centerId.txt");
  final request = http.Request("get", url)..encoding = latin5;
  final response = (await request.send()).stream.bytesToString();
  log("Towns requested for centerId: $centerId", name: "Requests");
  return response;
}
