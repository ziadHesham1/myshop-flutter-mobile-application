import 'package:flutter/material.dart';

class AuthAnimation {
  static late AnimationController animationController;

  static Animation<Size> heightAnimation = Tween<Size>(
    begin: const Size(double.infinity, 260),
    end: const Size(double.infinity, 320),
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    ),
  );
  static Animation<double> fadeAnimation = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeIn,
  );

  static Animation<Offset> slideAnimation = Tween<Offset>(
    begin: const Offset(0, -1.5),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
      parent: animationController, curve: Curves.fastOutSlowIn));
      
  static void initiateAnimation(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );
    // heightAnimation =
  }
}
