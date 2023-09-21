import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:meteo_uyari/screens/main_screen.dart';

void main() {
  testWidgets("Show alerts in main screen", (widgetTester) async {
    await http.runWithClient<Future<void>>(
        () => widgetTester.pumpWidget(
            MainScreen(savedCity: City(name: "Antalya", centerId: 90801))),
        () => MockClient((request) async {
              if (request.url ==
                  Uri.https("servis.mgm.gov.tr", "web/meteoalarm/today")) {
                return http.Response.bytes(
                  latin5.encode(
                      """[{"_id":"64fafe2e7205b9108890c4f1","text":{"yellow":"its description"},"weather":{"yellow":["thunderstorm"],"orange":[],"red":[]},"towns":{"yellow":[90801,90802,90803,90806,90808,90809,95301,95302,95303,95304,95305,95306,95307,95308,95309,95310,95311,95312],"orange":[],"red":[]},"alertNo":2023090805,"begin":"2023-09-08T15:00:00.000Z","end":"2023-09-09T15:00:00.000Z"}]"""),
                  304,
                  headers: {
                    "Content-Type": "application/json; charset=UTF-8",
                    "ETag": 'W/"27a-azo1NWLsxG62DBAKZ3AWx11Oc0I"',
                  },
                );
              } else {
                throw Error();
              }
            }));
    await widgetTester.pumpAndSettle();
    expect(find.byType(ListTile), findsOneWidget);
    final listTile = widgetTester.widget<ListTile>(find.byType(ListTile));
    expect(listTile.tileColor, equals(Colors.yellow));
  });
}
