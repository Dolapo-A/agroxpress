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

  double get totalPrice {
    var total = 0.00;

    for (var item in _list) {
      total += item.price * item.quantity;
    }

    return total;
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

  void increament(Product product) {
    product.increase();
    notifyListeners();
  }

  void decreament(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearcart() {
    _list.clear();
    notifyListeners();
  }
}
