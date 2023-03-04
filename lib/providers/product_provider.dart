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

  ProductProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
  void _setFavValue(newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    // toggle locally
    var oldStatus = isFavorite;
    _setFavValue(!isFavorite);
    notifyListeners();

    // update the new favorite status in the DB
    try {
      final response = await http.patch(FirebaseDBHelper.productUrl(id),
          body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      print('There\'s an error in the toggleFavoriteStatus Function');
      _setFavValue(oldStatus);
    }
  }
}
