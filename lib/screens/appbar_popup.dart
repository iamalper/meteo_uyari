import 'package:flutter/material.dart';
import 'package:meteo_uyari/classes/helpers.dart';

final appBarPopUp = switch (buildType) {
  MyBuildType.alpha => const AlertDialog(
      title: Text("Alfa sürümü"),
      content: SingleChildScrollView(
        child: Text(
            "Henüz erken geliştirme aşamasındaki sürümü kullanıyorsunuz. Uygulama büyük oranda değişebilir, güncellemeler ile bozulabilir."),
      ),
    ),
  MyBuildType.beta => const AlertDialog(
      title: Text("Beta sürümü"),
      content: SingleChildScrollView(
        child: Text(
            "Henüz yeterince test edilmemiş sürümü kullanıyorsunuz. Hatalar barındırabilir"),
      ),
    ),
  _ => throw UnimplementedError()
};
