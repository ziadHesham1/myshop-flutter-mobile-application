import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product_details_route';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Product selectedProduct =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
      body: Column(
        children: [
          ClipRRect(
            child: Image.network(
              selectedProduct.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              '\$${selectedProduct.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            selectedProduct.description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
