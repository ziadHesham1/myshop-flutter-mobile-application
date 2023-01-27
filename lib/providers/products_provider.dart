import 'package:flutter/material.dart';

import 'product_provider.dart';

class ProductsProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<ProductProvider> _productsItems = [
    ProductProvider(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductProvider(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductProvider(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductProvider(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<ProductProvider> get productItems {
    return [..._productsItems];
  }

  get favoriteProductItems {
    return _productsItems.where((element) => element.isFavorite).toList();
  }

  ProductProvider findProductById(productId) {
    return _productsItems.firstWhere((product) => product.id == productId);
  }

  void addProduct(id, title, description, price, imageUrl) {
    _productsItems.add(
      ProductProvider(
        id: id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
      ),
    );
  }

  void updateProduct(productId, title, description, price, imageUrl) {
    var productIndex =
        _productsItems.indexWhere((product) => product.id == productId);
    _productsItems[productIndex] = ProductProvider(
        id: _productsItems[productIndex].id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl);
  }
}
