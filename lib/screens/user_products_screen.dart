import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/products_provider.dart';
import 'package:myshop_flutter_application/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import 'add_product_screen.dart';

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
      body: Container(
        padding: const EdgeInsets.all(15),
        height: 300,
        child: ListView.builder(
          itemCount: productItems.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(productItems[index].title),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: productItems[index]);
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
