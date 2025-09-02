import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Shared Preference Async
final sharedPreferencesAsyncProvider = Provider<SharedPreferencesAsync>((_) =>
    SharedPreferencesAsync());


// Image Picker
final imagePickerProvider = Provider<ImagePicker>((_) => ImagePicker());