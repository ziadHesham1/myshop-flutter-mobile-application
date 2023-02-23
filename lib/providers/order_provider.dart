import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/firebase_helper.dart';

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
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => [..._orders];
  static List<Map<String, dynamic>> dummyExtractedListInMap = [
    {
      'id': 'NOdZ4FjvhZrF71xgqAV',
      'price': 29.99,
      'quantity': 1,
      'title': 'Red Shirt',
    },
    {
      'id': 'NOdZ4Lu1Khg9xOQfuNl',
      'price': 49.99,
      'quantity': 2,
      'title': ' A Pan',
    }
  ];

  Map<String, Map<String, dynamic>> dummyExtractedMap = {
    '-NOdZEcOiTWVFwxJu7uI': {
      'amount': 82.98,
      'dateTime': '2023-02-19T14:05:53.248052',
      'cartProducts': dummyExtractedListInMap,
    },
  };
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
          OrderModel(
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

  Future<void> fetchAndSetOrders() async {
    try {
      var response = await http.get(FirebaseHelper.ordersUrl);
      Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      List<OrderModel> loadedData = [];
      extractedData.forEach((key, value) {
                  print('Order with total amount ${value['amount']} is fetched from the database');

        loadedData.add(
          OrderModel(
              id: key,
              amount: value['amount'],
              dateTime: DateTime.parse(value['dateTime']),
              cartProducts: (value['cartProducts'] as List<dynamic> )
            .map(
              (item) => CartItemModel(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']),
            )
            .toList() ),
        );
      });
      _orders = loadedData;
    } catch (error) {
      print(
          'error in fetchAndSetOrders function!! couldn\'t fetch the data \n error:$error');

      // rethrow;
    }
  }
}
