import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'package:myshop_flutter_application/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart_route';
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var providedCartItem = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          buildSummaryCard(providedCartItem, context),
          // const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: (providedCartItem.cartItemsGetter).length,
              itemBuilder: (BuildContext context, int index) {
                var cartItemsGetter =
                    providedCartItem.cartItemsGetter.values.toList()[index];
                return CartItem(cartItemsGetter);
              },
            ),
          ),
        ],
      ),
    );
  }

  Card buildSummaryCard(CartProvider providedCartItem, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '\$${providedCartItem.totalAmount}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('ORDER NOW'),
            ),
          ],
        ),
      ),
    );
  }
}
