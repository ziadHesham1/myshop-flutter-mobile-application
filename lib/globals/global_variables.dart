class GlobalVariables {
  static const url =
      'https://myshop-flutter-app-9477e-default-rtdb.firebaseio.com';

  static Uri productsUrl = Uri.parse('$url/products.json');

  static Uri productUrl(productId) {
    return Uri.parse('$url/products/$productId.json');
  }

  static Uri cartItemsUrl = Uri.parse('$url/cartItems.json');

  static Uri cartItemUrl(productId) {
    return Uri.parse('$url/products/$productId.json');
  }
}
