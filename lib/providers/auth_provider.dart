import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/app_http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime(1022, 1, 1, 0, 0, 0);
  String _userId = '';
  static bool emailExist = false;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != DateTime(1022, 1, 1, 0, 0, 0) &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return null;
  }

  String? get userId => _userId;
  Future<http.Response> _authenticate(
      String email, String password, String urlSegment) async {
    const String apiKey = 'AIzaSyBBLYo3hlo02dMWPx0LNGbGCmEQEjoiQ1Y';

    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');

    http.Response response = await http.post(url,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    return response;
  }

  Future<void> signUp(String email, String password) async {
    try {
      http.Response response = await _authenticate(email, password, 'signUp');
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['idToken'] != null &&
          decodedResponse['email'] == email) {
        debugPrint('account created successfully');
      }

      if (response.statusCode >= 400 &&
          decodedResponse['error']['message'] == 'EMAIL_EXISTS') {
        throw AppHttpException('this email already exists');
      } else {
        _token = decodedResponse['idToken'];
        _userId = decodedResponse['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(
              decodedResponse['expiresIn'],
            ),
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      http.Response response =
          await _authenticate(email, password, 'signInWithPassword');
      var decodedResponse = json.decode(response.body);
      _token = decodedResponse['idToken'];
      _userId = decodedResponse['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            decodedResponse['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
