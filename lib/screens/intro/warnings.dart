import 'package:flutter/material.dart';

class Warnings extends StatelessWidget {
  final void Function() onContiune;
  const Warnings({super.key, required this.onContiune});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Uyarı"),
        const Text(
            "Bu bir hava durumu uygulaması değildir. Sadece hava durumu uyarılarını gösterir ve bildirir."),
        const Text(
            "Veriler kamuya açıktır ve Meteoroloji Genel Müdürlüğü MeteoUyarı sisteminden alınmaktadır."),
        const Text(
            "Uyarılar bilgilendirme amaçlıdır. Bu uygulama ve geliştiricileri, sunulan  doğruluğunu ve zamanında ulaşacağını garanti edemez."),
        ElevatedButton(
          onPressed: onContiune,
          child: const Text("Tamam"),
        ),
      ],
    );
  }
}
