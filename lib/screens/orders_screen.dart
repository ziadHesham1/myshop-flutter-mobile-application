import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/widgets/main_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_route';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var totalPayment = 88.75;
    var paymentDate = DateTime.now;
    // List<Product> purchasedProducts = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          ListTile(
            title: Text(totalPayment.toString()),
            subtitle: Text(paymentDate.toString()),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_drop_down),
            ),
          )
        ],
      ),
    );
  }
}
