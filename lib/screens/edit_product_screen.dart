import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/products_provider.dart';

import '../providers/product_provider.dart';

class EditProductScreen extends StatelessWidget {
  static const routeName = '/EditProductScreen';
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /* ProductProvider providedProduct =
        ModalRoute.of(context)!.settings.arguments as ProductProvider;
 */
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          child: ListView(
            children:  [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
