import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_mate_app/app_providers.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/model/user_model.dart';
import 'package:movie_mate_app/core/service/hive_service.dart';
import 'package:movie_mate_app/core/service/shared_pref_service.dart';
import 'package:movie_mate_app/features/main/profile/repository/user_repository.dart';
import 'package:path_provider/path_provider.dart';

class UserController extends ChangeNotifier {

  UserController(
      this._userRepository,
      this._sharedPrefService,
      this._imagePicker,
  );

  final UserRepository _userRepository;
  final SharedPrefService _sharedPrefService;
  final ImagePicker _imagePicker;


  UserModel? _user;
  UserModel? get user => _user;

  bool _hasChanges = false;
  bool get hasChanges => _hasChanges;

  File? _newSelectedImageFile;
  File? get newSelectedImageFile => _newSelectedImageFile;


  Future<void> loadUser() async {
    final currentUserId = await _sharedPrefService.getString(SharedPrefKeys.currentUserId);
    debugPrint('Current User ID: $currentUserId');
    if (currentUserId == null) {
      return;
    }
    _user = _userRepository.getUser(currentUserId);
    notifyListeners();
  }

  void updateName(String name) {
    if (_user == null) return;
    _user = _user!.copyWith(name: name);
    _hasChanges = true;
    notifyListeners();
  }

  Future<void> selectNewImage() async {
    final selectedXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedXFile == null) return;
    _newSelectedImageFile = File(selectedXFile.path);
    _hasChanges = true;
    notifyListeners();
  }

  Future<void> saveChanges() async {
    if (_user == null) return;
    final userImageFilePath = _user?.imageFilePath ?? '';
    // Deleting Old File
    if (userImageFilePath.isNotEmpty) {
      final oldFile = File(userImageFilePath);
      if (await oldFile.exists()) {
        oldFile.delete();
        debugPrint('Old File Deleted');
      }
    }

    if (_newSelectedImageFile != null) {
      final tempFileName = _newSelectedImageFile!.path
          .split('/')
          .last;
      final tempFileExtension = '.${tempFileName.split('.').last}';

      final directory = await getApplicationDocumentsDirectory();
      final newFileName = '${DateTime.now().millisecondsSinceEpoch}$tempFileExtension';
      final newFilePath = '${directory.path}/$newFileName';
      await _newSelectedImageFile!.copy(newFilePath);

      _user = _user!.copyWith(imageFilePath: newFilePath);
      _newSelectedImageFile = null;
    }

    _userRepository.updateUser(_user!);
    _hasChanges = false;
    notifyListeners();
    loadUser();
  }

}

final userControllerProvider = ChangeNotifierProvider<UserController>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  final sharedPrefService = ref.read(sharedPrefServiceProvider);
  final imagePicker = ref.read(imagePickerProvider);

  return UserController(userRepository, sharedPrefService, imagePicker);
});