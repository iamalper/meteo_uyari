import 'package:flutter/material.dart';
import 'package:meteo_uyari/themes.dart';

class Warnings extends StatelessWidget {
  final void Function() onContinue;
  const Warnings({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Uyarı", style: MyTextStyles.big()),
        const Text(
            "Bu bir hava durumu uygulaması değildir. Sadece hava durumu uyarılarını gösterir ve bildirir.",
            style: MyTextStyles.medium()),
        const Text(
            "Veriler kamuya açıktır ve Meteoroloji Genel Müdürlüğü MeteoUyarı sisteminden alınmaktadır.",
            style: MyTextStyles.medium()),
        const Text(
            "Uyarılar bilgilendirme amaçlıdır. Bu uygulama ve geliştiricileri, sunulan  doğruluğunu ve zamanında ulaşacağını garanti edemez.",
            style: MyTextStyles.medium()),
        ElevatedButton(
          onPressed: onContinue,
          child: const Text("Tamam", style: MyTextStyles.medium()),
        ),
      ],
    );
  }
}
