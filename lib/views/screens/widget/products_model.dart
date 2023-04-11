import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/models/product_model.dart';
import 'package:agroxpresss/provider/wishlist_provider.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({required this.products, Key? key}) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(
            productList: widget.products,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 9),
        child: Stack(
          children: [
            Container(
              // width: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(59, 21, 21, 21),
                        spreadRadius: 1,
                        blurRadius: 50,
                        offset: Offset(0, 5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    child: SizedBox(
                        height: 125,
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.products['productImage'][0],
                            placeholder: (context, url) {
                              return LinearProgressIndicator(
                                minHeight: 2,
                                backgroundColor:
                                    Color.fromARGB(77, 67, 115, 102),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(208, 67, 115, 102)),
                              );
                              // return Icon(Icons.home);
                            },
                            errorWidget: (context, url, error) {
                              return Icon(
                                Icons.image_not_supported_rounded,
                                color: Colors.grey[400],
                              );
                            })),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Text(
                      widget.products['productName'],
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                              color: grainsColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            widget.products['category'],
                            // textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: getCurrency(),
                                style: TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.products['price'].toString(),
                                style: onSale != 0
                                    ? TextStyle(
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold)
                                    : TextStyle(
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                            TextSpan(text: ''),
                            onSale != 0
                                ? TextSpan(
                                    text: ((1 -
                                                (widget.products['discount'] /
                                                    100)) *
                                            widget.products['price'])
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))
                                : TextSpan(),
                            TextSpan(
                              text: '/KG',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold),
                            ),
                          ])),
                        ),
                        IconButton(
                            iconSize: 20,
                            onPressed: () {
                              Provider.of<WishListProvider>(context,
                                              listen: false)
                                          .getWishItems
                                          .firstWhereOrNull((wish) =>
                                              wish.documentId ==
                                              widget.products['productId']) !=
                                      null
                                  ? context
                                      .read<WishListProvider>()
                                      .removeWish(widget.products['productId'])
                                  : Provider.of<WishListProvider>(context,
                                          listen: false)
                                      .addWishItem(
                                      widget.products['productName'],
                                      widget.products['price'],
                                      1,
                                      widget.products['inStock'],
                                      widget.products['productImage'],
                                      widget.products['productId'],
                                      widget.products['sellerUid'],
                                      widget.products['category'],
                                    );
                            },
                            icon: context
                                        .watch<WishListProvider>()
                                        .getWishItems
                                        .firstWhereOrNull((wish) =>
                                            wish.documentId ==
                                            widget.products['productId']) !=
                                    null
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  )
                                : Icon(Icons.favorite_outline_outlined)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
                    left: 0,
                    top: 10,
                    child: Container(
                      height: 25,
                      width: 65,
                      decoration: BoxDecoration(
                          color: generalColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Save ${widget.products['discount'].toString()}%',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  ),
            Positioned(
              left: 0,
              top: 10,
              child: widget.products['inStock'] == 0
                  ? Container(
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.transparent,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
