import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/products_provider.dart';
import 'package:myshop_flutter_application/screens/edit_product_screen.dart';
import 'package:myshop_flutter_application/widgets/main_drawer.dart';
import 'package:myshop_flutter_application/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../screens/add_product_screen.dart';
import '../screens/user_product_item.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user_products_screen';
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  @override
  Widget build(BuildContext context) {
    var productItems = Provider.of<ProductsProvider>(context).productItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const MainDrawer(),
      body: ListView.builder(
        itemCount: productItems.length,
        itemBuilder: (context, index) {
          return UserProductItem(productItems[index]);
        },
      ),
    );
  }
}
