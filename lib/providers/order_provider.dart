import 'package:flutter/cupertino.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';

class OrderItemModel {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItemModel> cartProducts;

  OrderItemModel({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.cartProducts,
  });
}

class OrdersProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItemModel> _orders = [];
  List<OrderItemModel> get orders => [..._orders];

  void addOrder(List<CartItemModel> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItemModel(
          id: DateTime.now().toString(),
          amount: total,
          cartProducts: cartProducts,
          dateTime: DateTime.now(),
        ));

    notifyListeners();
  }
}
