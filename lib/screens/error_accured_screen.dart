import 'package:flutter/material.dart';

class ErrorAccruedScreen extends StatelessWidget {
  final Function() tryAgainFunction;
  const ErrorAccruedScreen({
    required this.tryAgainFunction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Error Accrued, check your internet connection'),
        ElevatedButton(
          onPressed: tryAgainFunction,
          child: const Text('Try again'),
        )
      ],
    ));
  }
}
