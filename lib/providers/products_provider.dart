import 'package:flutter/material.dart';

import 'product_provider.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  ProductsProvider() {
    print('ProductsProvider is called');
  }

  // ignore: prefer_final_fields
  List<ProductProvider> _products = [
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
    return [..._products];
  }

  get favoriteProductItems {
    return _products.where((element) => element.isFavorite).toList();
  }

  ProductProvider findProductById(productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  void addProduct(id, title, description, double price, imageUrl) {
    const url = 'https://myshop-flutter-app-9477e-default-rtdb.firebaseio.com';

    ProductProvider productToAdd;
    /*  bool nameExist = _products.firstWhereOrNull(
        (ProductProvider element) => element.title.contains(newProduct.title))!=null?true:false; */
    int sameNameCount = _products
        .where((ProductProvider element) => element.title.contains(title))
        .length;

    if (sameNameCount > 0) {
      productToAdd = ProductProvider(
          id: id,
          title: '$title ($sameNameCount)',
          description: description,
          price: price,
          imageUrl: imageUrl);
    } else {
      productToAdd = ProductProvider(
          id: id,
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl);
    }
    _products.add(productToAdd);
    notifyListeners();
  }

  void updateProduct(
      productId, title, description, price, imageUrl, isFavorite) {
    var productIndex =
        _products.indexWhere((product) => product.id == productId);
    _products[productIndex] = ProductProvider(
      id: _products[productIndex].id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
    );
    notifyListeners();
  }

  void deleteProduct(productId) {
    var productIndex =
        _products.indexWhere((element) => element.id == productId);

    _products.removeAt(productIndex);
    notifyListeners();
  }
}
