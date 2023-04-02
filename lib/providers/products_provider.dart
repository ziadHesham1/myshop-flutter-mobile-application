
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../models/firebase_db_helper.dart';
import 'product_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  // i can't make token final because this error
  String authToken = '';
  String userId = '';
  ProductsProvider.empty();
  ProductsProvider(this.userId, this.authToken, this._products) {
    debugPrint('ProductsProvider is called');
  }

  // ignore: prefer_final_fields
  List<ProductProvider> _products = [];

  List<ProductProvider> get productItems {
    return [..._products];
  }

  List<ProductProvider> get favoriteProductItems {
    return _products.where((element) => element.isFavorite).toList();
  }

  ProductProvider findProductById(productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  String sameTitleCounter(String newString) {
    bool nameExist = _products.firstWhereOrNull((ProductProvider element) =>
                element.title.contains(newString)) !=
            null
        ? true
        : false;

    int sameNameCounter = nameExist
        ? _products
            .where(
                (ProductProvider element) => element.title.contains(newString))
            .length
        : 0;

    if (sameNameCounter > 0) {
      return '$newString ($sameNameCounter)';
    } else {
      return newString;
    }
  }

  Future<void> addProduct(title, description, double price, imageUrl) async {
    title = sameTitleCounter(title);
    // pushing new product to database
    Map<String, dynamic> newProductMap = {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      // 'authToken': authToken,
      // 'userId': userId,
      'creatorId': userId
    };

    try {
      final http.Response response = await http.post(
          FirebaseDBHelper.productsUrl(authToken),
          body: json.encode(newProductMap));
      _products.add(ProductProvider(
        id: json.decode(response.body)['name'],
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        authToken: authToken,
        userId: userId,
      ));
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  void pushDummyProduct() {
    List<ProductProvider> dummyProducts = [
      ProductProvider(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
      ProductProvider(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      ),
      ProductProvider(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl:
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      ),
      ProductProvider(
        id: 'p4',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      ),
    ];
    for (var product in dummyProducts) {
      addProduct(
          product.title, product.description, product.price, product.imageUrl);
    }
    notifyListeners();
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    try {
      final http.Response response = await http.get(filterByUser
          ? FirebaseDBHelper.productsUrl(authToken, creatorId: userId)
          : FirebaseDBHelper.productsUrl(authToken));
      final http.Response favoriteResponse = await http.get(
          FirebaseDBHelper.userFavoritesUrl(token: authToken, userId: userId));

      final Map<String, dynamic>? extractedData =
          json.decode(response.body) as Map<String, dynamic>?;
      final Map<String, dynamic>? favoritesData =
          json.decode(favoriteResponse.body);
      if (extractedData != null) {
        if (!extractedData.containsKey('error')) {
          List<ProductProvider> loadedData = [];
          extractedData.forEach((key, value) {
            debugPrint(
                'Product : ${value['title']} is fetched from the database');
            loadedData.add(ProductProvider(
              id: key,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isFavorite:
                  favoritesData == null ? false : favoritesData[key] ?? false,
              authToken: authToken /* value['authToken'] */,
              userId: userId,
            ));
          });
          _products = loadedData;
          notifyListeners();
        } else {
          var errorMessage =
              'Error in fetchAndSetProducts Fn: ${extractedData['error']}';
          debugPrint(errorMessage);
          throw (errorMessage);
        }
      } else {
        var errorMessage =
            'Error in fetchAndSetProducts Fn: the extractedData = null';
        debugPrint(errorMessage);
        // throw (errorMessage);
      }
    } catch (error) {
      var errorMessage =
          'Error caught in the fetchAndSetProducts function in the ProductsProvider ${error.toString()}';
      debugPrint(errorMessage);
      throw (errorMessage);
    }
  }

  Future<void> updateProduct(
      productId, title, description, price, imageUrl, isFavorite) async {
    int productIndex =
        _products.indexWhere((product) => product.id == productId);
    if (productIndex >= 0) {
      try {
        Map<String, dynamic> newProductMap = {
          'title': title,
          'description': description,
          'price': price,
          'imageUrl': imageUrl,
          'isFavorite': false,
        };
        await http.patch(FirebaseDBHelper.productUrl(productId, authToken),
            body: json.encode(newProductMap));
        debugPrint('the product $title should be updated on firebase');
        _products[productIndex] = ProductProvider(
          id: _products[productIndex].id,
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl,
          isFavorite: isFavorite,
        );
        notifyListeners();
      } catch (error) {
        debugPrint('error in the updateProduct function $error');
        rethrow;
      }
    } else {
      debugPrint('update failed!! Product not found');
    }
  }

  Future<void> deleteProduct(productId) async {
    var productIndex =
        _products.indexWhere((element) => element.id == productId);
    // delete from the DB
    // store the product that will be deleted temporary
    // in case there is a problem in deleting it from the DB
    ProductProvider? existingProduct = _products[productIndex];
    // delete the desired product locally
    _products.removeAt(productIndex);
    // to update the UI immediately when the product is deleted and restore it
    // if there's an error and deleting it from the DB failed
    notifyListeners();

    http.Response response =
        await http.delete(FirebaseDBHelper.productUrl(productId, authToken));
    // check if there's an error with deleting the product from the DB
    // it insert the product back to the product list and throw an error
    if (response.statusCode >= 400) {
      _products.insert(productIndex, existingProduct);
      notifyListeners();
      throw ('Couldn\'t delete product');
    }
    //
    existingProduct = null;

    notifyListeners();
  }

  Future<void> deleteAllProducts() async {
    // delete from the DB
    // store the product that will be deleted temporary
    // in case there is a problem in deleting it from the DB
    var existingProduct = _products;
    // delete the desired product locally
    _products = [];
    // to update the UI immediately when the product is deleted and restore it
    // if there's an error and deleting it from the DB failed
    notifyListeners();

    http.Response response =
        await http.delete(FirebaseDBHelper.productsUrl(authToken));
    // check if there's an error with deleting the product from the DB
    // it insert the product back to the product list and throw an error
    if (response.statusCode >= 400) {
      _products = existingProduct;
      notifyListeners();
      throw ('Couldn\'t delete product');
    }
    //
    existingProduct = [];

    notifyListeners();
  }
}
