import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/town.dart';
import 'package:meteo_uyari/themes.dart';
import '../models/alert.dart';
import '../models/formatted_datetime.dart';

class AlertsPage extends StatelessWidget {
  ///[alerts] are shown to user.
  ///
  ///It's safe to pass empty list.
  final List<Alert> alerts;

  ///[cityName] is shown to user.
  final String cityName;

  final bool devMode;

  ///Page for listing alerts for a single city.
  const AlertsPage(
      {super.key,
      required this.alerts,
      required this.cityName,
      this.devMode = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$cityName için hava durumu uyarıları",
          style: const MyTextStyles.big(),
        ),
        Divider(
          height: MediaQuery.sizeOf(context).height * 0.02,
          color: Colors.transparent,
        ),
        if (devMode)
          Expanded(
            child: _AlertList(alerts: _demoAlerts),
          )
        else if (alerts.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/screen_icons/safe-weather.png",
                height: MediaQuery.sizeOf(context).height / 3,
                width: MediaQuery.sizeOf(context).width / 3,
                fit: BoxFit.contain,
              ),
              const Text(
                "Herhangi bir uyarı yok",
                style: MyTextStyles.medium(),
              ),
            ],
          )
        else
          Expanded(
            child: _AlertList(alerts: alerts),
          ),
      ],
    );
  }
}

class _AlertList extends StatelessWidget {
  const _AlertList({
    required this.alerts,
  });

  final List<Alert> alerts;

  @override
  Widget build(BuildContext context) {
    //Material widget in here is a workaround for
    //https://github.com/flutter/flutter/issues/86584#issuecomment-916407888
    return Material(
      child: ListView.separated(
        itemBuilder: (context, index) => alerts[index].alertBoxTile,
        separatorBuilder: (context, index) => Divider(
          height: MediaQuery.sizeOf(context).height * 0.02,
          color: Colors.transparent,
        ),
        itemCount: alerts.length,
      ),
    );
  }
}

final _demoAlerts = [
  Alert(
      no: "230134",
      severity: Severity.orange,
      hadise: Hadise.hot,
      description: "deneme deneme",
      towns: {Town(id: 93855)},
      beginTime: FormattedDateTime.now(),
      endTime: FormattedDateTime.now()),
  Alert(
      no: "230134",
      severity: Severity.red,
      hadise: Hadise.wind,
      description: "deneme deneme 123 123",
      towns: {Town(id: 94523)},
      beginTime: FormattedDateTime.now(),
      endTime: FormattedDateTime.now())
];
