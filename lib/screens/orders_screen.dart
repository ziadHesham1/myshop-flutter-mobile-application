import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_route';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providedOrders = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const MainDrawer(),
      body: ListView.builder(
        itemCount: providedOrders.orders.length,
        itemBuilder: (BuildContext context, int index) {
          var orders = providedOrders.orders;
          return OrderItem(orders[index]);
        },
      ),
    );
  }
}
