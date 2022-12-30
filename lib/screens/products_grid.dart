import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';

import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;
  const ProductGrid(this.showFavorites, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ProductsProvider>(context);
    // view all or favorites items only based on the showFavorites boolean value
    final providedProducts = showFavorites
        ? providerData.favoritesItemsGetter
        : providerData.allItemsGetter;
    return GridView.builder(
      // grid items dimensions
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      // grid items number
      itemCount: providedProducts.length,
      // repeat the returned widget for each item in the grid
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // getting ProductProvider for each item in products list
        value: providedProducts[i] as ProductProvider,
      // widget shown inside each grid item
        child: const ProductItem(),
      ),
    );
  }
}
