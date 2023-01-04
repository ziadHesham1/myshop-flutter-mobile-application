import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/screens/orders_screen.dart';
import 'package:myshop_flutter_application/screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
          ),
          buildListTile(context, 'Shop', Icons.shop, '/'),
          buildListTile(
              context, 'Orders', Icons.credit_card, OrdersScreen.routeName),
          buildListTile(
              context, 'Manage Products', Icons.edit, UserProductsScreen.routeName),
        ],
      ),
    );
  }

  ListTile buildListTile(ctx, t, icon, screenroute) {
    return ListTile(
      leading: Icon(icon),
      title: Text(t),
      onTap: () {
        Navigator.of(ctx).pushReplacementNamed(screenroute);
      },
    );
  }
}
