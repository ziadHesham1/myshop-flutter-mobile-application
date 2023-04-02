import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/product_provider.dart';
import 'package:myshop_flutter_application/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';

import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;
  final bool _isLoading;

  const ProductGrid(this.showFavorites, this._isLoading, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ProductGrid is called');

    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);
    // view all or favorites items only based on the showFavorites boolean value
    final List<ProductProvider> providedProducts = showFavorites
        ? productsProvider.favoriteProductItems
        : productsProvider.productItems;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : providedProducts.isEmpty
            ? AddNewProductsWidget(productsProvider)
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
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
                    value: providedProducts[i],
                    // widget shown inside each grid item
                    child: ProductItem(),
                  ),
                ),
              );
  }
}

class AddNewProductsWidget extends StatefulWidget {
  final ProductsProvider productsProvider;
  const AddNewProductsWidget(
    this.productsProvider, {
    super.key,
  });

  @override
  State<AddNewProductsWidget> createState() => _AddNewProductsWidgetState();
}

class _AddNewProductsWidgetState extends State<AddNewProductsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              child: const Text('Add a product')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.productsProvider.pushDummyProduct();
                });
              },
              child: const Text('Add dummy products')),
        ],
      ),
    );
  }
}
