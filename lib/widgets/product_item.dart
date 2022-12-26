import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/models/product.dart';

import '../screens/product_details_screen.dart';

   bool isInternetConnected = false;
class ProductItem extends StatelessWidget {
  static const routeName = '/product_item_route';
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    // bool isInternetConnected = true;

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
            leading:
                buildIconButton(context, Icons.favorite_border_outlined, () {}),
            trailing:
                buildIconButton(context, Icons.local_grocery_store, () {}),
          ),
          child:
              // ignore: dead_code
              isInternetConnected ? imageUsingInternet : imageWithoutInternet,
        ),
      ),
    );

    /* InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailsScreen.routeName,
        arguments: product,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              height: 50,
              color: Colors.black,
              child: Text(
                product.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
   */
  }

  IconButton buildIconButton(ctx, icon, fn) {
    return IconButton(
      icon: Icon(icon),
      color: Theme.of(ctx).colorScheme.secondary,
      onPressed: fn,
    );
  }
}
