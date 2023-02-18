import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'package:myshop_flutter_application/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/products_grid.dart';
import '../widgets/main_drawer.dart';

enum FilterOptions { favorite, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

bool errorAccrued = false;

var _isInit = true;
bool _isLoading = false;

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoriteOnly = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _isLoading = true);

      print('ProductsOverviewScreen called for the first time');
      // Provider.of<ProductsProvider>(context).pushDummyProduct();
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .catchError((e) {
        errorAccrued = true;
      }).then((value) {
        setState(() => _isLoading = false);
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  var isCartFetched = false;
  @override
  Widget build(BuildContext context) {
    if (!isCartFetched) {
      Provider.of<CartProvider>(context).fetchAndSetCartItems().catchError((e) {
        print(
            'fetchAndSetCartItems failed in the ProductsOverviewScreen didChangeDependencies');
      });
      isCartFetched = true;
    }
    print('ProductsOverviewScreen is called');

    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          // favorite-all drop menu
          PopupMenuButton(
            onSelected: (selectedItem) {
              setState(() {
                selectedItem == FilterOptions.favorite
                    ? _showFavoriteOnly = true
                    : _showFavoriteOnly = false;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: FilterOptions.favorite,
                  child: Text('Favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('All'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
          // cart icon button
          Consumer<CartProvider>(
            builder: (_, CartProvider providedCart, Widget? ch) => AppBadge(
              value: providedCart.itemsCount().toString(),
              child: ch as Widget,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.local_grocery_store),
            ),
          ),
          /*  () {
                setState(() {
                  widget.productsProvider.pushDummyProduct();
                });
        */
          IconButton(
            onPressed: () {
              setState(() {
                productsProvider.pushDummyProduct();
              });
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                productsProvider.deleteAllProducts();
              });
            },
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: errorAccrued
          ? newMethod()
          : ProductGrid(_showFavoriteOnly, _isLoading),
    );
  }
 Center newMethod() {
    return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Error Accrued, check your internet connection'),
      ElevatedButton(
          onPressed: () {
            setState(() {
              _isInit = true;
              errorAccrued = false;
            });
          },
          child: const Text('Try again'))
    ],
  ));
  }

}


