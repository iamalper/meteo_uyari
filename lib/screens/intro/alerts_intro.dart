import 'package:flutter/material.dart';

class AlertsIntro extends StatelessWidget {
  final void Function() onContiune;
  const AlertsIntro({super.key, required this.onContiune});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Şu durumlarda uyarı alacaksınız"),
        const Text("""
          Soğuk Hava Dalgası
          Sıcak Hava Dalgası
          Sis
          Zirai Don
          Buzlanma ve Don
          Toz Taşınımı
          Kar Erimesi
          Çığ
          Kar
          Gökgürültülü Sağanak Yağış (Yıldırım, Dolu, Hortum)
          Kuvvetli Rüzgar ve Fırtına
          Yağmur/Sağanak
            """),
        const Text("Bunu daha sonra değiştirebileceksiniz"),
        ElevatedButton(onPressed: onContiune, child: const Text("Devam"))
      ],
    );
  }
}
