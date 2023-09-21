import 'package:flutter/material.dart';

class Warnings extends StatefulWidget {
  final void Function(bool isDebugPressed) onContiune;
  const Warnings({super.key, required this.onContiune});

  @override
  State<Warnings> createState() => _WarningsState();
}

class _WarningsState extends State<Warnings> {
  bool _isButonDebug = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Uyarı"),
        const Text(
            "Bu bir hava durumu uygulaması değildir. Sadece hava durumu uyarılarını gösterir ve bildirir."),
        const Text(
            "Veriler kamuya açıktır ve Meteoroloji Genel Müdürlüğü MeteoUyarı sisteminden alınmaktadır."),
        const Text(
            "Uyarılar bilgilendirme amaçlıdır. Bu uygulama ve geliştiricileri, sunulan  doğruluğunu ve zamanında ulaşacağını garanti edemez."),
        ElevatedButton(
          onPressed: () => widget.onContiune(_isButonDebug),
          child: _isButonDebug
              ? const Text("HATA AYIKLAMA MODU")
              : const Text("Tamam"),
          onLongPress: () => setState(() {
            _isButonDebug = !_isButonDebug;
          }),
        ),
      ],
    );
  }
}
