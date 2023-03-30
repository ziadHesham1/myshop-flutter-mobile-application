class FirebaseDBHelper {
  static const url =
      'https://myshop-flutter-app-9477e-default-rtdb.firebaseio.com';
  static Uri productsUrl(String token, {String? creatorId}) {
    if (creatorId == null) {
      return Uri.parse('$url/products.json?auth=$token');
    } else {
      return Uri.parse(
          '$url/products.json?auth=$token&orderBy="creatorId"&equalTo="$creatorId"');
    }
  }

  static Uri productUrl(productId, String token) {
    return Uri.parse('$url/products/$productId.json?auth=$token');
  }

  static Uri userFavoritesUrl({
    required String token,
    required String userId,
    String? productId,
  }) {
    if (productId != null) {
      return Uri.parse(
          '$url/userFavorites/$userId/$productId.json?auth=$token');
    } else {
      return Uri.parse('$url/userFavorites/$userId.json?auth=$token');
    }
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
