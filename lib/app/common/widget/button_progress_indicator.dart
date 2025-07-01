import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A widget that displays a platform-specific progress indicator for buttons.
///
/// This widget uses [CupertinoActivityIndicator] on iOS and
/// [CircularProgressIndicator] on Android with appropriate styling.
class ButtonProgressIndicator extends StatelessWidget {
  /// Creates a button progress indicator.
  ///
  /// [color] is an optional parameter to set the color of the indicator 
  /// on platforms other than iOS (which always uses white).
  const ButtonProgressIndicator({super.key, this.color});

  /// Optional color for the progress indicator (default is white).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Platform.isIOS
          ? CupertinoActivityIndicator(
              color: Colors.white,
            )
          : CircularProgressIndicator(
              color: color ?? Colors.white,
              strokeWidth: 2,
            ),
    );
  }
}
