import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/features/main/profile/controller/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settingsController = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'language'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: DropdownButton<String>(
                value: settingsController.language,
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: "en-US", child: Text("English")),
                  DropdownMenuItem(value: "es-ES", child: Text("Spanish")),
                  DropdownMenuItem(value: "fr-FR", child: Text("French")),
                  DropdownMenuItem(value: "de-DE", child: Text("German")),
                  DropdownMenuItem(value: "it-IT", child: Text("Italian")),
                  DropdownMenuItem(value: "hi-IN", child: Text("Hindi")),
                  DropdownMenuItem(value: "ur-PK", child: Text("Urdu")),
                  DropdownMenuItem(value: "ja-JP", child: Text("Japanese")),
                  DropdownMenuItem(value: "ko-KR", child: Text("Korean")),
                  DropdownMenuItem(
                    value: "zh-CN",
                    child: Text("Chinese (Simplified)"),
                  ),
                  DropdownMenuItem(value: "ru-RU", child: Text("Russian")),
                  DropdownMenuItem(value: "ar-SA", child: Text("Arabic")),
                ],
                onChanged: (lan) {
                  if (lan != null) {
                    ref.read(settingsControllerProvider).setLanguage(lan);
                    final parts = lan.split('-');
                    context.setLocale(Locale(parts[0], parts.length > 1 ? parts[1] : null));
                  }
                },
              ),
            ),

            SizedBox(height: 20),

            SwitchListTile(
              title: Text('adult_movies'.tr()),
              activeTrackColor: primaryColor,
              activeColor: white,
              inactiveThumbColor: isDarkMode ? white : black,
              value: settingsController.adult,
              onChanged: (value) {
                ref.read(settingsControllerProvider).toggleAdult(value);
              },
            ),

            const Divider(),
            ListTile(
              title: Text(
                'theme'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: Text('dark_theme'.tr()),
              activeTrackColor: primaryColor,
              activeColor: white,
              inactiveThumbColor: isDarkMode ? white : black,
              value: settingsController.darkTheme,
              onChanged: (value) {
                ref.read(settingsControllerProvider).toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
