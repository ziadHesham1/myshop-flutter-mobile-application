import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

// ignore: constant_identifier_names

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          backgroundLayout(),
          foregroundLayout(deviceSize),
        ],
      ),
    );
  }

  SingleChildScrollView foregroundLayout(Size deviceSize) {
    return SingleChildScrollView(
      child: SizedBox(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            logo(),
            const AuthCard(),
          ],
        ),
      ),
    );
  }

  Flexible logo() {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
        // adds the rotation in the logo
        transform: Matrix4.rotationZ(-8 * pi / 180)

          /// cascade operator(..) calls the next operator but does't return its return value
          /// it return what the previous statement returns
          ..translate(-10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepOrange.shade900,
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: const Text(
          'MyShop',
          style: TextStyle(
            // color: Theme.of(context).accentTextTheme.titleLarge.color,
            fontSize: 50,
            fontFamily: 'Anton',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Container backgroundLayout() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
            const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 1],
        ),
      ),
    );
  }
}
