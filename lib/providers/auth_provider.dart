import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  late String token;
  late DateTime expiryDate;
  late String userId;
  static bool emailExist = false;

  Future<void> signUp(String email, String password) async {
    const apiKey = 'AIzaSyBBLYo3hlo02dMWPx0LNGbGCmEQEjoiQ1Y';

    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');

    try {
      http.Response response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      var decodedResponse = json.decode(response.body);
      print('signup response: $decodedResponse');
      if (decodedResponse['idToken'] != null &&
              decodedResponse['email'] == email ||
          decodedResponse['error']['message'] == 'EMAIL_EXISTS') {
        emailExist = true;
      }
      print('emailExist = $emailExist');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
 Future<void> signIn(String email, String password) async {
    const apiKey = 'AIzaSyBBLYo3hlo02dMWPx0LNGbGCmEQEjoiQ1Y';

    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');

    try {
      http.Response response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      var decodedResponse = json.decode(response.body);
      print('signin response: $decodedResponse');
     /* if (decodedResponse['idToken'] != null &&
              decodedResponse['email'] == email ||
          decodedResponse['error']['message'] == 'EMAIL_EXISTS') {
        emailExist = true;
      }*/
      // print('emailExist = $emailExist');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
