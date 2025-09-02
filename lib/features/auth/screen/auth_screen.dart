import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/extension/context_extension.dart';
import 'package:movie_mate_app/core/model/user_model.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';
import 'package:movie_mate_app/core/widget/error_dialog_adaptive.dart';
import 'package:movie_mate_app/core/widget/loading_dialog.dart';
import 'package:movie_mate_app/core/widget/no_profile_picture_widget.dart';
import 'package:movie_mate_app/core/widget/profile_picture_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/features/auth/controller/auth_controller.dart';
import 'package:movie_mate_app/features/auth/models/auth_state.dart';
import 'package:movie_mate_app/features/main/main_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  File? selectedImageFile;
  String? name;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    selectedImageFile = null;
    name = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final floatingActionButtonTheme = Theme.of(
      context,
    ).floatingActionButtonTheme;
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;
    final elevatedButtonTheme = Theme.of(context).elevatedButtonTheme;

    ref.listen<AuthState>(
      authControllerProvider,
          (previous, next) {
        next.whenOrNull(
          authenticating: () {
            _showLoadingDialog(context);
          },
          failed: (String errorMessage) {
            Navigator.of(context, rootNavigator: true).pop(); // Popping Progress Indicator Dialog
            showAdaptiveDialog(
              context: context,
              builder: (context) => ErrorDialogAdaptive(
                errorMessage: errorMessage,
                onDismiss: (() {
                  Navigator.pop(context);
                }),
              ),
            );
          },
          authenticated: () {
            Navigator.of(context, rootNavigator: true).pop(); // Popping Progress Indicator Dialog
            _showLoadingDialog(context);
          },
          userDataStored: () {
            Navigator.of(context, rootNavigator: true).pop(); // Popping Progress Indicator Dialog
            context.showSnackBar(message: 'You are Authenticated Successfully');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => MainScreen())
            );
          },
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Authentication Text
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Authentication',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User Image
                      (selectedImageFile != null
                          ? Center(
                              child: ProfilePictureWidget(
                                backgroundImage: Image.file(
                                  selectedImageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  const NoProfilePictureWidget(),
                                  // Pick Photo
                                  FloatingActionButton.small(
                                    onPressed: (() {
                                      ref.read(authControllerProvider.notifier).pickImageFromGallery(
                                        onPicked: ((File pickedImageFile) {
                                          setState(() {
                                            selectedImageFile = pickedImageFile;
                                          });
                                        })
                                      );
                                    }),
                                    shape: floatingActionButtonTheme.shape,
                                    backgroundColor: floatingActionButtonTheme
                                        .backgroundColor,
                                    foregroundColor: floatingActionButtonTheme
                                        .foregroundColor,
                                    child: Icon(selectedImageFile != null ? Icons.edit_outlined : Icons.add),
                                  ),
                                ],
                              ),
                            )),

                      SizedBox(height: 50),

                      // Name
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: 'Name (Optional)',
                            hintStyle: inputDecorationTheme.hintStyle,
                            enabledBorder: inputDecorationTheme.enabledBorder,
                            focusedBorder: inputDecorationTheme.focusedBorder,
                            suffixIcon: Icon(Icons.person, color: white),
                          ),
                          onChanged: ((String? text) {
                            setState(() => name = text);
                          }),
                        ),
                      ),

                      // Note
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'NOTE:',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'Please Note that the Name and Picture is optional. you can edit after Authentication',
                          style: textTheme.bodyMedium,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Authenticate Button
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: (() {
                            final user = UserModel(
                              uid: DateTime.now().millisecondsSinceEpoch.toString(),
                              createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: name,
                            );
                            ref
                                  .read(authControllerProvider.notifier)
                                  .authenticate(user: user, userImageFile: selectedImageFile);
                          }),
                          style: elevatedButtonTheme.style,
                          child: Text('Authenticate'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(canDismissOnPop: false),
    );
  }
}
