import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/loaded_products.dart';
import 'package:myshop_flutter_application/screens/cart_screen.dart';
import 'package:myshop_flutter_application/widgets/main_drawer.dart';
import 'package:myshop_flutter_application/widgets/product_item.dart';

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
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemCount: LOADEDPRODUCTS.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductItem(LOADEDPRODUCTS[index]);
        },
      ),
    );
  }
}
