import 'package:flutter/material.dart';

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
  // ignore: prefer_final_fields
  Map<String, CartItemModel> _cartItems = {};

  Map<String, CartItemModel> get cartItems => {..._cartItems};

  void addCartItem(String productId, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      // change quantity
      _cartItems.update(
          productId,
          (existingItem) => CartItemModel(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: (existingItem.quantity) + 1,
              ));
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItemModel(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void removeSingleItem(productId) {

    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if ((_cartItems[productId]!.quantity) > 1) {
      _cartItems.update(
          productId,
          (existingItem) => CartItemModel(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: (existingItem.quantity) - 1,
              ));
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
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
