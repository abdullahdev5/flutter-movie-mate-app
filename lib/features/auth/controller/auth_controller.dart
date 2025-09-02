import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_mate_app/app_providers.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/model/user_model.dart';
import 'package:movie_mate_app/core/service/hive_service.dart';
import 'package:movie_mate_app/core/service/shared_pref_service.dart';
import 'package:movie_mate_app/features/auth/models/auth_state.dart';
import 'package:movie_mate_app/features/auth/service/local_auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends StateNotifier<AuthState> {

  AuthController(
      this._localAuthService,
      this._imagePicker,
      this._sharedPrefService,
      this._hiveService,
  ) : super(AuthState.initial());

  final LocalAuthService _localAuthService;
  final ImagePicker _imagePicker;
  final SharedPrefService _sharedPrefService;
  final HiveService _hiveService;


  Future<void> authenticate({
    required UserModel user,
    File? userImageFile,
  }) async {
    state = AuthState.authenticating();

    await Future.delayed(Duration(seconds: 3));

    try {
      final isAvailable = await _localAuthService.isAvailable();

      debugPrint('IsAvailable: $isAvailable');

      if (!isAvailable) {
        state = AuthState.failed('Oops! Your device didn\'t supports any Biometrics');
        return;
      }

      final authenticated = await _localAuthService.authenticate();
      debugPrint('Authenticated: $authenticated');
      if (!authenticated) {
        state = AuthState.failed('Failed to Authenticate. You are not the device owner!');
        await _localAuthService.stopAuthentication();
        return;
      }

      if (authenticated) {
        state = AuthState.authenticated();
        await _storeUserData(user: user, userImageFile: userImageFile);
        _sharedPrefService.setBool(SharedPrefKeys.isSignedIn, true);
        state = AuthState.userDataStored();
      }

    } catch (e) {
      state = AuthState.failed(e.toString());
    }
  }

  Future<void> _storeUserData({
    required UserModel user,
    required File? userImageFile,
  }) async {
    if (userImageFile != null) {
      final tempFileName = userImageFile.path
          .split('/')
          .last;
      final tempFileExtension = '.${tempFileName
          .split('.')
          .last}';

      final directory = await getApplicationDocumentsDirectory();
      final newFileName = 'user_image_${DateTime
          .now()
          .millisecondsSinceEpoch}$tempFileExtension';

      final newFilePath = '${directory.path}/$newFileName';
      await userImageFile.copy(newFilePath);

      user.imageFilePath = newFilePath; // Setting New File Path to User

      debugPrint('User Image File Path: ${user.imageFilePath}');
    }

    _hiveService.userBox.put(user.uid, user.toMap());
    _sharedPrefService.setString(SharedPrefKeys.currentUserId, user.uid);
  }


  Future<void> pickImageFromGallery({required Function(File pickedImageFile) onPicked}) async {
    final XFile? pickedXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedXFile == null) return;

    final pickedFile = File(pickedXFile.path);
    onPicked(pickedFile);
  }


}


final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
        (ref) => AuthController(
          ref.read(localAuthServiceProvider), // Local Auth Service
          ref.read(imagePickerProvider), // Image Picker
          ref.read(sharedPrefServiceProvider), // Shared Preference Async
          ref.read(hiveServiceProvider), // Shared Preference Async
        )
);