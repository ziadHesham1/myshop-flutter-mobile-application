import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/product_model.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';

import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ProductsProvider>(context);
    final providedProducts = providerData.itemsGetter;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: providedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (context) => providedProducts[i] as ProductModel,
        child: const ProductItem(),
      ),
    );
  }
}
