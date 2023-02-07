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

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoriteOnly = false;
  var _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _isLoading = true);

      print('ProductsOverviewScreen called for the first time');
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .then((value) {
        setState(() => _isLoading = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      drawer: const MainDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavoriteOnly, _isLoading),
    );
  }
}
