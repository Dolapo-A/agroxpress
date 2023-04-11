class Product {
  String name;
  double price;
  int quantity;
  int inStock;
  List imagesUrl;
  String documentId;
  String category;
  String sellerUid;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.inStock,
    required this.imagesUrl,
    required this.documentId,
    required this.sellerUid,
    required this.category,
  });

  void increase() {
    // quantity <= inStock ? quantity = inStock :
    quantity++;
  }

  void decrease() {
    // quantity <= 1 ? quantity = 0 :
    quantity--;
  }
}
