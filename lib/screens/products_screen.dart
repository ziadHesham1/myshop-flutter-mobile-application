import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/loaded_products.dart';
import 'package:myshop_flutter_application/screens/cart_screen.dart';
import 'package:myshop_flutter_application/widgets/main_drawer.dart';
import 'package:myshop_flutter_application/widgets/product_item.dart';

class ProductsScreen extends StatelessWidget {
  // the data
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;

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
      body: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: bodyWidth * 0.5,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children:
            LOADEDPRODUCTS.map((product) => ProductItem(product)).toList(),
      ),
    );
  }
}
