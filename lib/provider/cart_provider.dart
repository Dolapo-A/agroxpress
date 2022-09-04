import 'package:agroxpresss/models/product_model.dart';
import 'package:flutter/widgets.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  void addItem(String name, double price, int quantity, int inStock,
      List imagesUrl, String documentId, String sellerUid) {
    final product = Product(
        name: name,
        price: price,
        quantity: quantity,
        inStock: inStock,
        imagesUrl: imagesUrl,
        documentId: documentId,
        sellerUid: sellerUid);

    _list.add(product);

    notifyListeners();
  }
}
