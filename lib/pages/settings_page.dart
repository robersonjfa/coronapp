import 'package:flutter/material.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: "Configurações",
      children: [
        MaterialColorPickerSettingsTile(
          settingKey: 'opc_primary_color',
          title: 'Cor da aplicação',
        ),
        SwitchSettingsTile(
          settingKey: 'opc_show_photo',
          title: 'Exibir foto?',
        )
      ],
    );
  }
}
