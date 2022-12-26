import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/models/product.dart';
import 'package:myshop_flutter_application/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  static const routeName = '/product_item_route';
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
  }
}
