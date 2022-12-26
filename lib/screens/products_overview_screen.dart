import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../screens/products_grid.dart';
import '../widgets/main_drawer.dart';

class ProductsOverviewScreen extends StatelessWidget {
  // the data
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: const Icon(Icons.local_grocery_store),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: const ProductGrid(),
    );
  }
}
