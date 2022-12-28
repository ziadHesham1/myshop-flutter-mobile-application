import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/product_model.dart';
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
    var product = Provider.of<ProductModel>(context);
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
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailsScreen.routeName,
        arguments: product,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            // favorite icon
            leading: Consumer<ProductModel>(
              builder: (BuildContext context, value, _) =>
                  buildIconButton(
                      context,
                      value.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined, () {
                value.toggleFavoriteStatus();
              }),
            ),
            // add to cart icon
            trailing:
                buildIconButton(context, Icons.local_grocery_store, () {}),
          ),
          child:
              isInternetConnected ? imageUsingInternet : imageWithoutInternet,
        ),
      ),
    );
  }

  IconButton buildIconButton(ctx, icon, fn) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.deepOrange,
      onPressed: fn,
    );
  }
}
