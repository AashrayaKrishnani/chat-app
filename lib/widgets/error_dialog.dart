import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(
      {Key? key,
      this.title = 'Dev Messed Up! 😅',
      this.content =
          'You can be Nice and send us a ScreenShot of this (at loveaash3@gmail.com) so we can solve it out! 🙏',
      this.buttonMessage = 'Ahh Alright!',
      this.bgColor,
      this.textColor,
      this.showCancel = false})
      : super(key: key);

  final String title;
  final String content;
  final String buttonMessage;
  final Color? bgColor;
  final Color? textColor;
  final bool showCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgColor ?? Theme.of(context).errorColor,
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      content: Text(
        content,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      actions: [
        if (showCancel)
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              )),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              buttonMessage,
              style: const TextStyle(color: Colors.red),
            ))
      ],
    );
  }
}
