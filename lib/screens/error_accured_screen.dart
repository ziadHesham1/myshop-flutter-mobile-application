import 'package:flutter/material.dart';

class ErrorAccruedScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorAccruedScreen({
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(errorMessage),
        ElevatedButton(
          onPressed: (){},
          child: const Text('Try again'),
        )
      ],
    ));
  }
}
