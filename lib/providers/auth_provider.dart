import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/app_http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime(1022, 1, 1, 0, 0, 0);
  String _userId = '';
  String _email = '';

  Timer? _authTimer;

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

  String get email => _email;

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
      _email = decodedResponse['email'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            decodedResponse['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      await storeUserData();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> storeUserData() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var tokenData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', tokenData);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }
      String? userDataString = prefs.getString('userData');
      if (userDataString != null) {
        Map<String, dynamic> extractedUserData =
            json.decode(userDataString) as Map<String, dynamic>;
        debugPrint(extractedUserData.toString());
        DateTime extractedExpiryDate =
            DateTime.parse(extractedUserData['expiryDate']);
        if (extractedExpiryDate.isBefore(DateTime.now())) {
          return false;
        }
        _token = extractedUserData['token'];
        _userId = extractedUserData['userId'];
        _expiryDate = extractedExpiryDate;
        _autoLogout();
        print('inside tryAutoLogin: isAuth = $isAuth');
        return true;
      } else {
        debugPrint('the output from prefs.getString(UserData)==null');
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> emptySharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void logout() {
    _token = '';
    _userId = '';
    _expiryDate = DateTime(1022, 1, 1, 0, 0, 0);
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    emptySharedPrefs();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    int timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    print(
        'auto logout function activated, user will logout after $timeToExpiry seconds');
  }
}
