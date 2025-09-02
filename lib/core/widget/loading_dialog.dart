import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, this.canDismissOnPop = true});

  final bool canDismissOnPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog.adaptive(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicatorAdaptive()],
        ),
      ),
    );
  }
}
