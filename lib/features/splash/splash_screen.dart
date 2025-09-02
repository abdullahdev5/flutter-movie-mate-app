import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/service/shared_pref_service.dart';
import 'package:movie_mate_app/features/auth/screen/auth_screen.dart';
import 'package:movie_mate_app/features/boarding/screen/on_boarding_screen.dart';
import 'package:movie_mate_app/features/main/main_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    Timer(Duration(seconds: 1), () async {
      final sharedPrefService = ref.read(sharedPrefServiceProvider);
      final isUserSeenOnBoarding = await sharedPrefService.getBool(SharedPrefKeys.isUserSeenOnBoarding);
      if (isUserSeenOnBoarding == null || isUserSeenOnBoarding == false) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => OnBoardingScreen())
        );
        return;
      }

      final isSignedIn = await sharedPrefService.getBool(SharedPrefKeys.isSignedIn);
      final currentUserId = await sharedPrefService.getString(SharedPrefKeys.currentUserId);
      if (isSignedIn == true && currentUserId != null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MainScreen())
        );
        return;
      } else {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => AuthScreen())
        );
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/app_icon.png',
          fit: BoxFit.cover,
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
