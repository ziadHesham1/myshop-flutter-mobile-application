import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myshop_flutter_application/models/firebase_db_helper.dart';

class CartItemModel {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  String authToken = '';
  CartProvider.empty();
  CartProvider(this.authToken, this._cartItems) {
    debugPrint('CartProvider is called');
  }

  Map<String, CartItemModel> _cartItems = {};

/*
*which id is which!!! : 
*product id
  is the key in the map and the productId in the DB map
*the cart item id 
  is the cart model.id which is the cart item value.id
  and the id of the item in the DB which is automatically generated 

putIfAbsent(
            value['productId'],
            () => CartItemModel(
              id: key,
              title: value['title'],
              price: value['price'],
              quantity: value['quantity'],
            ),

*/

  Map<String, CartItemModel> get cartItems => {..._cartItems};

  Future<void> addCartItem(String productId, String title, double price) async {
    var existingItemId = '';
    var existingItemQuantity = 0;
    if (_cartItems.containsKey(productId)) {
      // change quantity locally
      _cartItems.update(productId, (item) {
        existingItemId = item.id;
        existingItemQuantity = item.quantity;

        return CartItemModel(
          id: item.id,
          title: item.title,
          price: item.price,
          quantity: (item.quantity) + 1,
        );
      });
      // change quantity in DB
      await http.patch(FirebaseDBHelper.cartItemUrl(existingItemId, authToken),
          body: json.encode({
            'quantity': existingItemQuantity + 1,
          }));
    } else {
      //response

      final response = await http.post(FirebaseDBHelper.cartItemsUrl(authToken),
          body: json.encode({
            'productId': productId,
            'title': title,
            'price': price,
            'quantity': 1,
          }));
      _cartItems.putIfAbsent(
        productId,
        () => CartItemModel(
          id: json.decode(response.body)['name'],
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> fetchAndSetCartItems() async {
    try {
      final http.Response response =
          await http.get(FirebaseDBHelper.cartItemsUrl(authToken));
      final Map<String, dynamic>? extractedData =
          json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData != null) {
        if (!extractedData.containsKey('error')) {
          Map<String, CartItemModel> loadedData = {};
          extractedData.forEach((key, value) {
            debugPrint(
                'Product : ${value['title']} is fetched from the database');
            loadedData.putIfAbsent(
              value['productId'],
              () => CartItemModel(
                id: key,
                title: value['title'],
                price: value['price'],
                quantity: value['quantity'],
              ),
            );
          });
          _cartItems = loadedData;
          notifyListeners();
        } else {
          String errorMessage =
              'Error in fetchAndSetCartItems Fn: ${extractedData['error']}';
          throw HttpException(errorMessage);
        }
      } else {
        String hintMessage =
            'Hint from fetchAndSetCartItems Fn: the extractedData = null';
        debugPrint(hintMessage);
        // throw HttpException(errorMessage);
      }
    } catch (error) {
      String errorMessage =
          'Error caught in the fetchAndSetCartItems function in the CartProvider : ${error.toString()}';
      throw HttpException(errorMessage);
    }
  }

// remove the product interlay from cart
// working local and on DB
  Future<void> removeItem(String id) async {
    debugPrint('inside removeItem Fn');
    try {
      CartItemModel? deletedItem = _cartItems.remove(id);
      notifyListeners();
      // remove that item from the DB
      if (deletedItem != null) {
        http.Response response = await http
            .delete(FirebaseDBHelper.cartItemUrl(deletedItem.id, authToken));
        debugPrint(
            'trying to delete product with id responseId from cart in DB');
        // check if there's an error return the product back in cart
        if (response.statusCode >= 400) {
          debugPrint(
              'Error!! Can\'t delete product with id responseId from cart DB');
          _cartItems.putIfAbsent(id, () => deletedItem!);
          notifyListeners();
        }
        deletedItem = null;
      }
    } catch (error) {
      debugPrint(
          'error in the removeItem function in the cart provider class: ${error.toString()}');
      rethrow;
    }
  }

// remove single item if there's more that one of the same product in cart
// working locally and DB
  Future<void> removeSingleItem(productId) async {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    // Working local and DB

    if ((_cartItems[productId]!.quantity) > 1) {
      _cartItems.update(productId, (item) {
        return CartItemModel(
          id: item.id,
          title: item.title,
          price: item.price,
          quantity: (item.quantity) - 1,
        );
      });
      var existingItem = _cartItems[productId];
      if (existingItem != null) {
        var url = FirebaseDBHelper.cartItemUrl(existingItem.id, authToken);
        http.patch(url, body: json.encode({'quantity': existingItem.quantity}));
        notifyListeners();
      } else {
        debugPrint(
            'in removeSingleItem Fn : product quantity couldn\'t be updated because there\'s no item with this product id : $productId ');
      }
    }
    // DB and local is WORKING
    else {
              debugPrint(
'removeItem says :removeSingleItem is calling me');
      removeItem(productId);
      // _cartItems.remove(productId);
    }
  }

  Future<void> clearCart() async {
    try {
      var existingCartItems = cartItems;
      _cartItems = {};
      notifyListeners();

      http.Response response =
          await http.delete(FirebaseDBHelper.cartItemsUrl(authToken));
      if (response.statusCode >= 400) {
        _cartItems = existingCartItems;
        notifyListeners();
        debugPrint('Error!! can\'t couldn\'t clear cart  ');
      }
    } catch (error) {
      rethrow;
    }
  }

  int itemsCount() {
    return _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price + value.quantity;
    });
    return total;
  }
}
