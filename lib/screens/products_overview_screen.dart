import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'package:myshop_flutter_application/screens/error_accured_screen.dart';
import 'package:myshop_flutter_application/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
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

  var isCartFetched = false;
  @override
  Widget build(BuildContext context) {
    print('ProductsOverviewScreen is called');

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

            /*  Consumer<CartProvider>(
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
            ), */
            FutureBuilder(
              future: Provider.of<CartProvider>(context, listen: false)
                  .fetchAndSetCartItems()

              /*  if (!isCartFetched) {
      Provider.of<CartProvider>(context,listen:false).fetchAndSetCartItems().catchError((e) {
        print(
            'fetchAndSetCartItems failed in the ProductsOverviewScreen didChangeDependencies');
      });
      isCartFetched = true;
    } */
              ,
              builder: (context, snapshot) {
                bool isWaiting =
                    snapshot.connectionState == ConnectionState.waiting;
                bool errorAccrued = snapshot.hasError;
                return Consumer<CartProvider>(
                  builder: (_, CartProvider providedCart, Widget? ch) =>
                      AppBadge(
                    value: isWaiting || errorAccrued
                        ? '!'
                        : providedCart.itemsCount().toString(),
                    child: ch as Widget,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    icon: const Icon(Icons.local_grocery_store),
                  ),
                );
              },
            )
          ],
        ),
        drawer: const MainDrawer(),
        body: FutureBuilder(
          future: Provider.of<ProductsProvider>(context, listen: false)
              .fetchAndSetProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return ErrorAccruedScreen(tryAgainFunction: () {});
            } else {
              return ProductGrid(_showFavoriteOnly, _isLoading);
            }
          },
        ));
  }
/*  errorAccrued
          ? ErrorAccruedScreen(tryAgainFunction: () => null)
          : , */
}
