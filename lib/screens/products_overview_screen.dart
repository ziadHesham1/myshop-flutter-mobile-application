import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'package:myshop_flutter_application/widgets/badge.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
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
          Consumer<CartProvider>(
            builder: (_, CartProvider cart, Widget? ch) => Badge(
              value: cart.itemsCount().toString(),
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
      body: ProductGrid(_showFavoriteOnly),
    );
  }
}
