import 'package:flutter/material.dart';

class CustomErrorDialog {
  static Future<void> errorDialog(context, Object error) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(error.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Okay'))
          ],
        );
      },
    );
  }
}
