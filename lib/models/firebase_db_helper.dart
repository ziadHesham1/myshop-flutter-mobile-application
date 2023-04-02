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

  static Uri cartItemsUrl({required String token, required String userId}) =>
      Uri.parse('$url/cartItems/$userId.json?auth=$token');

  static Uri cartItemUrl(
          {required String cartItemId,
          required String token,
          required String userId}) =>
      Uri.parse('$url/cartItems/$userId/$cartItemId.json?auth=$token');

  static Uri ordersUrl(String token, String userId) =>
      Uri.parse('$url/orders/$userId.json?auth=$token');
}
