import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/firebase_db_helper.dart';

class OrderModel {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItemModel> cartProducts;

  OrderModel({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.cartProducts,
  });
}

class OrdersProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  String authToken = '';
  OrdersProvider.empty();
  OrdersProvider(this.authToken, this._orders) {
    debugPrint('CartProvider is called');
  }
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];
 
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
      var response = await http.post(FirebaseDBHelper.ordersUrl(authToken),
          body: json.encode(orderMap));

      _orders.insert(
          // the index of the new element
          0,
          // the new element
          OrderModel(
            id: json.decode(response.body)['name'],
            amount: total,
            cartProducts: cartProducts,
            dateTime: dateTime2,
          ));
      notifyListeners();
    } catch (error) {
      debugPrint(
          'Error in addOrder function!!! : couldn\'t add the order \n error message : $error');
    }
  }

  Future<void> fetchAndSetOrders() async {
    try {
      var response = await http.get(FirebaseDBHelper.ordersUrl(authToken));
      Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      List<OrderModel> loadedData = [];
      extractedData.forEach((key, value) {
        debugPrint(
            'Order with total amount ${value['amount']} is fetched from the database');

        loadedData.add(
          OrderModel(
              id: key,
              amount: value['amount'],
              dateTime: DateTime.parse(value['dateTime']),
              cartProducts: (value['cartProducts'] as List<dynamic>)
                  .map(
                    (item) => CartItemModel(
                        id: item['id'],
                        title: item['title'],
                        price: item['price'],
                        quantity: item['quantity']),
                  )
                  .toList()),
        );
      });
      _orders = loadedData;
    } catch (error) {
      debugPrint(
          'error in fetchAndSetOrders function!! couldn\'t fetch the data \n error:$error');

      // rethrow;
    }
  }
}
