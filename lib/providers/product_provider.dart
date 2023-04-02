import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myshop_flutter_application/models/firebase_db_helper.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  String authToken = '';
  String userId = '';

  ProductProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    this.authToken = '',
    this.userId = '',
  });

  void _setFavValue(newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String theToken) async {
    // toggle locally
    var oldStatus = isFavorite;
    _setFavValue(!isFavorite);

    // update the new favorite status in the DB
    try {
      final response = await http.put(
          FirebaseDBHelper.userFavoritesUrl(
              token: theToken, userId: userId, productId: id),
          body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        throw ('There\'s an error in the toggleFavoriteStatus Function : ${response.reasonPhrase}');
      }
    } catch (error) {
      _setFavValue(oldStatus);
      throw ('There\'s an error in the toggleFavoriteStatus Function');
    }
  }
}
