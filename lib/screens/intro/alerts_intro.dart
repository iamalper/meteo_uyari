import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';

class AlertsIntro extends StatelessWidget {
  final void Function() onContiune;
  const AlertsIntro({super.key, required this.onContiune});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Şu durumlarda uyarı alacaksınız"),
        ...Hadise.values.map((e) => Text(e.baslik)),
        const Text("Bunu daha sonra değiştirebileceksiniz"),
        ElevatedButton(onPressed: onContiune, child: const Text("Devam"))
      ],
    );
  }
}
