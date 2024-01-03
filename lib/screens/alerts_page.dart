import 'package:flutter/material.dart';
import 'package:meteo_uyari/themes.dart';
import '../models/alert.dart';

class AlertsPage extends StatelessWidget {
  ///[alerts] are shown to user.
  ///
  ///It's safe to pass empty list.
  final List<Alert> alerts;

  ///[cityName] is shown to user.
  final String cityName;

  ///Page for listing alerts for a single city.
  const AlertsPage({super.key, required this.alerts, required this.cityName});
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
        if (alerts.isEmpty)
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
