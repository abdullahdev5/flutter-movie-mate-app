import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod/riverpod.dart';

class LocalAuthService {

  final LocalAuthentication _localAuth = LocalAuthentication();


  Future<bool> isAvailable() async {
    final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    final bool isDeviceSupported = await _localAuth.isDeviceSupported();
    debugPrint('Can Authenticate with Biometrics: $canAuthenticateWithBiometrics');
    debugPrint('IsDeviceSupported: $isDeviceSupported');

    return canAuthenticateWithBiometrics && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    return await _localAuth.authenticate(
      localizedReason: 'We Need Your Biometrics for Authentication. We Don\'t Store Anything Personal. We Just Check Is You are the Device Owner.',
      options: AuthenticationOptions(
        biometricOnly: false, // Means User can Also Authenticate with Non-Biometric Authentications Such as Pin, Passcode
        useErrorDialogs: false,
      )
    );
  }

  Future<bool> stopAuthentication() async => await _localAuth.stopAuthentication();

}

final localAuthServiceProvider = Provider<LocalAuthService>((_) => LocalAuthService());