import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:meteo_uyari/models/alert.dart';

import '../classes/assets.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
      ),
      body: SettingsList(sections: [
        SettingsSection(title: const Text("Uyarılar"), tiles: [
          for (final hadise in Hadise.values)
            SettingsTile.switchTile(
              initialValue: true,
              onToggle: null,
              title: Text(hadise.baslik),
              leading: SizedBox(
                height: 40,
                width: 40,
                child: ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                  child: getHadiseImage(hadise),
                ),
              ),
            )
        ])
      ]),
    );
  }
}
