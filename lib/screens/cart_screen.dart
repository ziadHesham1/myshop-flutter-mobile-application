import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'package:myshop_flutter_application/providers/order_provider.dart';
import 'package:myshop_flutter_application/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart_route';
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // listening to the CartProvider
    var providedCartItems = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          // the design of the summery widget in the top of the screen
          Card(
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
                      '\$${providedCartItems.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<OrdersProvider>(context, listen: false)
                          .addOrder(providedCartItems.cartItems.values.toList(),
                              providedCartItems.totalAmount
                              );
                      providedCartItems.clearCart();
                    },
                    child: const Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Expanded used with ListView.builder the take all the space available in the screen
          Expanded(
            // view the list of the products added to cart (providedCartItem.cartItemsGetter)
            child: ListView.builder(
              itemCount: (providedCartItems.cartItems).length,
              itemBuilder: (BuildContext context, int index) {
                // providedCartItem.cartItemsGetter annotation is Map<String, CartItemModel>
                // both the key and values is needed in the CartItem widget
                // assigning them to variable for cleaner code
                var cartItemsKeys =
                    providedCartItems.cartItems.keys.toList()[index];
                var cartItemsValues =
                    providedCartItems.cartItems.values.toList()[index];
                return CartItem(cartItemsKeys, cartItemsValues);
              },
            ),
          ),
        ],
      ),
    );
  }
}
