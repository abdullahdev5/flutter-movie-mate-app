import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';

class ErrorDialogAdaptive extends StatelessWidget {
  const ErrorDialogAdaptive({
    super.key,
    this.title = 'Error',
    required this.errorMessage,
    this.canDismissDialogOnPop = true,
    this.onDismiss,
  });

  final String title;
  final String errorMessage;
  final bool canDismissDialogOnPop;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final dialogTheme = Theme.of(context).dialogTheme;
    final textButtonTheme = Theme.of(context).textButtonTheme;
    return PopScope(
      canPop: canDismissDialogOnPop,
      child: AlertDialog.adaptive(
        backgroundColor: dialogTheme.backgroundColor,
        titleTextStyle: dialogTheme.titleTextStyle,
        contentTextStyle: dialogTheme.contentTextStyle,
        icon: Icon(Icons.warning_amber, color: red),
        title: Text(title),
        content: Text(errorMessage),
        actions: <TextButton>[
          TextButton(
            onPressed: onDismiss,
            style: textButtonTheme.style,
            child: Text('OK')
          )
        ],
      ),
    );
  }
}
