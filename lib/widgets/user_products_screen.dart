import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';
import '../screens/error_accured_screen.dart';
import '../screens/user_product_item.dart';
import 'main_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products_screen';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('User Products Screen build called');

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
              Provider.of<ProductsProvider>(context,listen: false).addProduct(
                'New Product',
                'this is an empty product',
                1000,
                'https://www.shareicon.net/data/128x128/2015/05/20/41190_empty_256x256.png',
              );
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
          bool errorAccrued = snapshot.hasError;
          if (isWaiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (errorAccrued) {
            debugPrint(
                'Error in fetchAndSetOrders FutureBuilder says : ${snapshot.error}');
            return const ErrorAccruedScreen(errorMessage: 'error accrued');
          } else {
            return RefreshIndicator(
              onRefresh: () => refreshProducts(context),
              child: Consumer<ProductsProvider>(
                builder:
                    (BuildContext context, productsProvider, Widget? child) =>
                        ListView.builder(
                  itemCount: productsProvider.productItems.length,
                  itemBuilder: (context, index) {
                    return UserProductItem(
                        productsProvider.productItems[index]);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> refreshProducts(BuildContext context) async =>
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts(filterByUser: true);
}
