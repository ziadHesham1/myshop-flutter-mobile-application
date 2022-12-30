import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/cart_provider.dart';
import 'package:myshop_flutter_application/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';

// عشان النت لما بيفصل البرنامج مش بيرضا يفتح
bool isInternetConnected = false;
// bool isInternetConnected = true;

class ProductItem extends StatelessWidget {
  static const routeName = '/product_item_route';
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<ProductProvider>(context);
    var providedCartItems = Provider.of<CartProvider>(context);
    var imageUsingInternet = Image.network(
      product.imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
    );

    var imageWithoutInternet = Image.asset(
      'no_internet.jpg',
      width: double.infinity,
      fit: BoxFit.cover,
    );
    return InkWell(
      // go to the product detail screen when the widget pressed
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailsScreen.routeName,
        arguments: product,
      ),
      // make the gird item corners rounded
      child: ClipRRect(
        // set rounded corners for the widget
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        // the grid item widget (GridTile)
        child: GridTile(
          // the bottom part of the grid item design
          footer: GridTileBar(
            backgroundColor: Colors.black87,

            // the title of th product center of the GridTileBar
            title: Text(product.title, textAlign: TextAlign.center),

            //toggled favorite icon on the left of the GridTileBar
            // listening to the ProductProvider the get (isFavorite) boolean value
            leading: Consumer<ProductProvider>(
              builder: (BuildContext context, value, _) => buildIconButton(
                  context,
                  // when icon pressed it toggle the isFavorite value and change its icon
                  value.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border_outlined, () {
                value.toggleFavoriteStatus();
              }),
            ),

            // cart icon on the left of the GridTileBar
            trailing: buildIconButton(context, Icons.local_grocery_store, () {
              providedCartItems.addCartItem(
                  product.id, product.title, product.price);
            }),
          ),
          //  the main child of the GridTile : the product image
          child:
              isInternetConnected ? imageUsingInternet : imageWithoutInternet,
        ),
      ),
    );
  }

// building the icon button using custom function for cleaner code
  IconButton buildIconButton(ctx, icon, fn) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.deepOrange,
      onPressed: fn,
    );
  }
}
