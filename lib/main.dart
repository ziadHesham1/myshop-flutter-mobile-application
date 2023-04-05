import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/auth_provider.dart';
import 'package:myshop_flutter_application/screens/loading_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/edit_product_screen.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart';

import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import 'widgets/user_products_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider.empty(),
          update: (BuildContext context, value,
                  ProductsProvider? previousProductsProvider) =>
              ProductsProvider(
            authToken: value.token ?? '',
            userId: value.userId ?? '',
            previousProductsProvider == null
                ? []
                : previousProductsProvider.productItems,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (context) => CartProvider.empty(),
          update: (BuildContext context, value,
                  CartProvider? previousCartProvider) =>
              CartProvider(
            authToken: value.token ?? '',
            userId: value.userId ?? '',
            previousCartProvider == null ? {} : previousCartProvider.cartItems,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (context) => OrdersProvider.empty(),
          update: (BuildContext context, value,
                  OrdersProvider? previousCartProvider) =>
              OrdersProvider(
            authToken: value.token ?? '',
            userId: value.userId ?? '',
            previousCartProvider == null ? [] : previousCartProvider.orders,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, AuthProvider authProvider, _) {
          debugPrint('myApp build is called');

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
                fontFamily: 'Lato'),
            home: _decideHomeScreen(authProvider),
            routes: {
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              ProductDetailsScreen.routeName: (context) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              AuthScreen.routeName: (context) => const AuthScreen(),
            },
          );
        },
      ),
    );
  }

  Widget _decideHomeScreen(AuthProvider authProvider) {
   
    return FutureBuilder(
      future: authProvider.tryAutoLogin(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
        bool canAutoLogin = snapshot.data ?? false;
        if (isWaiting) {
          return const LoadingScreen();
        } else {
          if (canAutoLogin) {
            return const ProductsOverviewScreen();
          } else {
            return const AuthScreen();
          }
        }
      },
    );
  }
}
