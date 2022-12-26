import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/loaded_products.dart';
import 'package:myshop_flutter_application/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart_route';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: LOADEDPRODUCTS.length,
        itemBuilder: (BuildContext context, int index) {
          return CartItem(LOADEDPRODUCTS[index]);
        },
      ),
    );
  }
}
