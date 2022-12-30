import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'package:myshop_flutter_application/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart_route';
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // listening to the CartProvider
    var providedCartItem = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          // the design of the summery widget in the top of the screen
          buildSummaryCard(providedCartItem, context),
          const SizedBox(height: 20),
          // Expanded used with ListView.builder the take all the space available in the screen
          Expanded(
            // view the list of the products added to cart (providedCartItem.cartItemsGetter)
            child: ListView.builder(
              itemCount: (providedCartItem.cartItemsGetter).length,
              itemBuilder: (BuildContext context, int index) {
                // providedCartItem.cartItemsGetter annotation is Map<String, CartItemModel>
                // both the key and values is needed in the CartItem widget
                // assigning them to variable for cleaner code
                var cartItemsKeys =
                    providedCartItem.cartItemsGetter.keys.toList()[index];
                var cartItemsValues =
                    providedCartItem.cartItemsGetter.values.toList()[index];
                return CartItem(cartItemsKeys,cartItemsValues);
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
