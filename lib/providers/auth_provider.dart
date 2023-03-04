import 'package:flutter/material.dart';
import '../models/firebase_auth_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;
  AuthProvider({
    required this.token,
    required this.expiryDate,
    required this.userId,
  });

  Future<void> signup() async {
    http.post(FirebaseAuthHelper.url,
        body: json.encode({
          "email": "[user@example.com]",
          "password": "[PASSWORD]",
          "returnSecureToken": true
        }));
  }
}
