class FirebaseDBHelper {
  static const url =
      'https://myshop-flutter-app-9477e-default-rtdb.firebaseio.com';

  static Uri productsUrl = Uri.parse('$url/products.json');

  static Uri productUrl(productId) {
    return Uri.parse('$url/products/$productId.json');
  }

  static Uri cartItemsUrl = Uri.parse('$url/cartItems.json');

  static Uri cartItemUrl(productId) {
    return Uri.parse('$url/cartItems/$productId.json');
  }

  static Uri ordersUrl = Uri.parse('$url/orders.json');
  static Uri orderUrl(productId) {
    return Uri.parse('$url/orders/$productId.json');
  }
}
