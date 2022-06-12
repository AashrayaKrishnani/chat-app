import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Snack extends SnackBar {
  Snack(
      {Key? key,
      this.text = 'Hello there ;p',
      this.bgColor,
      this.textColor,
      this.duration = const Duration(seconds: 2),
      this.padding = const EdgeInsets.all(10),
      this.action})
      : super(
          key: key,
          content: Text(
            text,
            style: TextStyle(color: textColor ?? Colors.white),
          ),
          padding: padding,
          action: action,
          backgroundColor: bgColor,
          duration: duration,
        );

  final String text;
  final Color? bgColor;
  final Color? textColor;
  final Duration duration;
  final EdgeInsets padding;
  final SnackBarAction? action;
}
