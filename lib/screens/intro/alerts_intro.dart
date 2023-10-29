import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/themes.dart';

class AlertsIntro extends StatelessWidget {
  final void Function() onContiune;
  const AlertsIntro({super.key, required this.onContiune});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Şu durumlarda uyarı alacaksınız",
          style: MyTextStyles.medium(),
        ),
        ...Hadise.values
            .map((e) => Text(e.baslik, style: const MyTextStyles.small())),
        const Text("Bunu daha sonra değiştirebileceksiniz",
            style: MyTextStyles.medium()),
        ElevatedButton(
            onPressed: onContiune,
            child: const Text("Devam", style: MyTextStyles.medium()))
      ],
    );
  }
}
