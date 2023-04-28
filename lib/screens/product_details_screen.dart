import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product_details_route';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider selectedProduct =
        ModalRoute.of(context)!.settings.arguments as ProductProvider;

    var imageUsingInternet = Image.network(
      selectedProduct.imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedProduct.title),
              background: Hero(
                tag: selectedProduct.id,
                child: ClipRRect(
                  child: imageUsingInternet,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Text(
              '\$${selectedProduct.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // the description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedProduct.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 800)
          ]))
        ],
      ),
    );
  }
}
