import 'package:agroxpresss/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class WishListProvider extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getWishItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addWishItem(
      String name,
      double price,
      int quantity,
      int inStock,
      List imagesUrl,
      String documentId,
      String sellerUid,
      String category) async {
    final product = Product(
        name: name,
        price: price,
        quantity: quantity,
        inStock: inStock,
        imagesUrl: imagesUrl,
        documentId: documentId,
        sellerUid: sellerUid,
        category: category);

    _list.add(product);

    notifyListeners();
  }

  void clearwish() {
    _list.clear();
    notifyListeners();
  }

  void removeWish(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }

  void removeWishItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }
}
