import 'package:flutter/material.dart';

final myDarkTheme = ThemeData.dark().copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size(100, 50)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))))),
);

final myLightTheme = ThemeData.light().copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size(100, 50)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))))),
);

@immutable
class MyTextStyles extends TextStyle {
  const MyTextStyles.big() : super(fontSize: 24);
  const MyTextStyles.medium() : super(fontSize: 18);
  const MyTextStyles.small() : super(fontSize: 16);
}
