import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/firebase_helper.dart';

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

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    try {
      var dateTime2 = DateTime.now();
      var orderMap = {
        'amount': total,
        'dateTime': dateTime2.toIso8601String(),
        'cartProducts': cartProducts
            .map((item) => {
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'quantity': item.quantity
                })
            .toList(),
      };
      var response = await http.post(FirebaseHelper.ordersUrl,
          body: json.encode(orderMap));

      _orders.insert(
          // the index of the new element
          0,
          // the new element
          OrderItemModel(
            id: json.decode(response.body)['name'],
            amount: total,
            cartProducts: cartProducts,
            dateTime: dateTime2,
          ));
      notifyListeners();
    } catch (error) {
      print(
          'Error in addOrder function!!! : couldn\'t add the order \n error message : $error');
    }
  }
}
