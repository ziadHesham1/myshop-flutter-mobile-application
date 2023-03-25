import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/auth_provider.dart';
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
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, value, _) {
          print('myApp build is called');

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
                fontFamily: 'Lato'),
            home: AuthProvider.emailExist
                ? const ProductsOverviewScreen()
                : const AuthScreen(),
            routes: {
              // '/': (context) => const ProductsOverviewScreen(),
              // '/': (context) => const AuthScreen(),
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
}
