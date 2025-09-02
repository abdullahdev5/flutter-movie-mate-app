import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/service/shared_pref_service.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/core/widget/no_profile_picture_widget.dart';
import 'package:movie_mate_app/core/widget/profile_picture_widget.dart';
import 'package:movie_mate_app/features/main/profile/controller/settings_controller.dart';
import 'package:movie_mate_app/features/main/profile/controller/user_controller.dart';
import 'package:movie_mate_app/features/main/profile/screen/saved_movies_screen.dart';
import 'package:movie_mate_app/features/main/profile/screen/settings_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  final _nameController = TextEditingController();
  ValueNotifier<bool> _isUserEditingName = ValueNotifier(false);


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userControllerProvider.notifier).loadUser();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    final userController = ref.watch(userControllerProvider);
    final user = userController.user;
    final hasChanges = userController.hasChanges;

    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicatorAdaptive()));
    }

    _nameController.text = user.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <TextButton>[
          if (hasChanges) TextButton(
            onPressed: (() {
              ref.read(userControllerProvider).saveChanges();
              _isUserEditingName.value = false;
            }),
            child: const Text('Save')
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  userController.newSelectedImageFile != null ? ProfilePictureWidget(
                    backgroundImage: Image.file(userController.newSelectedImageFile!),
                  ) : (user.imageFilePath != null ? ProfilePictureWidget(
                      backgroundImage: Image.file(File(user.imageFilePath!))
                  ) : NoProfilePictureWidget()),

                  FloatingActionButton.small(
                    onPressed: (() async {
                      await ref.read(userControllerProvider).selectNewImage();
                    }),
                    child: Icon(Icons.edit_outlined, color: white),
                  )
                ],
              ),
            ),

            SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Text(
                '${'name'.tr()}:',
                style: textTheme.labelMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ValueListenableBuilder(
                valueListenable: _isUserEditingName,
                builder: (context, isUserEditingName, child) {
                  return TextField(
                    controller: _nameController,
                    onChanged: (value) {
                      ref.read(userControllerProvider.notifier).updateName(value);
                    },
                    readOnly: !isUserEditingName,
                    canRequestFocus: isUserEditingName,
                    decoration: InputDecoration(
                      hintText: 'No Name Provided',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDarkMode ? white : black)
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)
                      ),
                      suffixIcon: IconButton(
                        onPressed: (() {
                          _isUserEditingName.value = !_isUserEditingName.value;
                        }),
                        icon: isUserEditingName ? Icon(Icons.close) : Icon(Icons.edit_outlined)
                      )
                    ),
                  );
                }
              ),
            ),

            SizedBox(height: 30),

            _buildSettingsItem(
              onPressed: (() {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen()));
              }),
              title: 'settings'.tr()
            ),

            _buildSettingsItem(
              onPressed: (() {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SavedMoviesScreen()));
              }),
              title: 'saved_movies'.tr()
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({VoidCallback? onPressed, required String title}) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.titleMedium,
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 15,),
          ],
        ),
      ),
    );
  }
}
