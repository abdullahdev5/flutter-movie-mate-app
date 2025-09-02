import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_mate_app/app_providers.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/service/hive_service.dart';
import 'package:movie_mate_app/core/theme/movie_mate_theme.dart';
import 'package:movie_mate_app/features/boarding/screen/on_boarding_screen.dart';
import 'package:movie_mate_app/features/main/profile/controller/settings_controller.dart';
import 'package:movie_mate_app/features/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();
    await HiveService.openBoxes();
  } catch (e) {
    debugPrint('Error: $e');
    throw Exception('Error: $e');
  }

  var currentLocale = Locale('en', 'US');

  final sharedPrefAsync = SharedPreferencesAsync();
  final language = await sharedPrefAsync.getString(SharedPrefKeys.language);
  if (language != null) {
    final languageParts = language.split('-');
    currentLocale = Locale(
      languageParts[0],
      languageParts.length > 1 ? languageParts[1] : null,
    );
  }
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fe', 'FR'),
        Locale('it', 'IT'),
        Locale('hi', 'IN'),
        Locale('ur', 'PK'),
        Locale('ja', 'JP'),
        Locale('ko', 'KR'),
        Locale('zh', 'CN'),
        Locale('ru', 'RU'),
        Locale('ar', 'SA'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: currentLocale,
      child: DevicePreview(
        enabled: false,
        builder: (context) {
          return ProviderScope(
            overrides: [
              sharedPreferencesAsyncProvider.overrideWithValue(sharedPrefAsync),
            ],
            child: App(),
          );
        },
      ),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsController = ref.watch(settingsControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Mate',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: MovieMateTheme.themeLight,
      darkTheme: MovieMateTheme.themeDark,
      themeMode: settingsController.darkTheme
          ? ThemeMode.dark
          : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
