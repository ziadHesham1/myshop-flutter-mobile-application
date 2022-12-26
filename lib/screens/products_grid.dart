import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

import '../loaded_products.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ProductsProvider>(context);
    final products = providerData.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return ProductItem(products[index]);
      },
    );
  }
}
