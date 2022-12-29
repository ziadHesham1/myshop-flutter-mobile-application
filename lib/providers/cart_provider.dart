import 'package:flutter/material.dart';

class _CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  _CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  var _cartItems = {};
  get cartItemsGetter => {..._cartItems};

  int itemsCount() {
    return _cartItems.length;
  }

  void addCartItem(String productId, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      // change quantity
      _cartItems.update(
          productId,
          (existingItem) => _CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: (existingItem.quantity) + 1,
              ));
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => _CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }
}
