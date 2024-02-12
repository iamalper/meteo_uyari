///Asset loader
library;

import 'package:flutter/material.dart';
import 'package:meteo_uyari/models/alert.dart';

ColorFiltered getHadiseImage(Hadise hadise,
        {Color foregroundColor = Colors.blue}) =>
    ColorFiltered(
        colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
        child: Image.asset("assets/alert_icons/${hadise.name}.png"));
