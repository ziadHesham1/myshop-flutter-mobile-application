import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';
import '../screens/user_product_item.dart';
import 'main_drawer.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user_products_screen';
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  @override
  Widget build(BuildContext context) {
    print('User Products Screen build called');
    var productsProvider = Provider.of<ProductsProvider>(context);

    var productItems = productsProvider.productItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              productsProvider.addProduct(
                'New Product',
                'this is a thing that can do a thing',
                1000,
                'http/dummy_website/dum.png',
              );
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await productsProvider.fetchAndSetProducts();
        },
        child: ListView.builder(
          itemCount: productItems.length,
          itemBuilder: (context, index) {
            return UserProductItem(productItems[index]);
          },
        ),
      ),
    );
  }
}
