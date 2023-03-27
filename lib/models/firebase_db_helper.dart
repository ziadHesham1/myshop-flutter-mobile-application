class FirebaseDBHelper {
  static const url =
      'https://myshop-flutter-app-9477e-default-rtdb.firebaseio.com';

  // static Uri productsUrl = Uri.parse('$url/products.json');
  static Uri productsUrl(String token) =>
      Uri.parse('$url/products.json?auth=$token');

  static Uri productUrl(productId, String token) {
    return Uri.parse('$url/products/$productId.json?auth=$token');
  }

  // static Uri cartItemsUrl = Uri.parse('$url/cartItems.json');
  static Uri cartItemsUrl(String token) =>
      Uri.parse('$url/cartItems.json?auth=$token');
  static Uri cartItemUrl(productId, String token) {
    return Uri.parse('$url/cartItems/$productId.json?auth=$token');
  }

  // static Uri ordersUrl = Uri.parse('$url/orders.json');
  static Uri ordersUrl(String token) =>
      Uri.parse('$url/orders.json?auth=$token');
  static Uri orderUrl(productId, String token) {
    return Uri.parse('$url/orders/$productId.json?auth=$token');
  }
}
