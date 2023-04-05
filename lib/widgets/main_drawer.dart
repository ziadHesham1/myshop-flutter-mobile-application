import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../screens/orders_screen.dart';
import '../widgets/user_products_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello ${authProvider.email}'),
          ),
          buildListTile(context, 'Shop', Icons.shop, '/'),
          const Divider(),
          buildListTile(
              context, 'Orders', Icons.credit_card, OrdersScreen.routeName),
          const Divider(),
          buildListTile(context, 'Manage Products', Icons.edit,
              UserProductsScreen.routeName),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('logout'),
            onTap: () {
              Navigator.of(context);

              authProvider.logout();
            },
          )
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
