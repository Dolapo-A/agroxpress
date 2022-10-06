import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/provider/wishlist_provider.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class VendorProductsModel extends StatefulWidget {
  final dynamic products;
  const VendorProductsModel({required this.products, Key? key})
      : super(key: key);

  @override
  State<VendorProductsModel> createState() => _VendorProductsModel();
}

class _VendorProductsModel extends State<VendorProductsModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
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
                              backgroundColor: Color.fromARGB(77, 67, 115, 102),
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
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.products['productName'],
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                SizedBox(
                  height: 10,
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
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: getCurrency(),
                            style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                        TextSpan(
                          text: widget.products['price'].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ])),
                      // IconButton(
                      //     onPressed: () {
                      //       Provider.of<WishListProvider>(context,
                      //                       listen: false)
                      //                   .getWishItems
                      //                   .firstWhereOrNull((wish) =>
                      //                       wish.documentId ==
                      //                       widget.products['productId']) !=
                      //               null
                      //           ? context
                      //               .read<WishListProvider>()
                      //               .removeWish(widget.products['productId'])
                      //           : Provider.of<WishListProvider>(context,
                      //                   listen: false)
                      //               .addWishItem(
                      //                   widget.products['productName'],
                      //                   widget.products['price'],
                      //                   1,
                      //                   widget.products['inStock'],
                      //                   widget.products['productImage'],
                      //                   widget.products['productId'],
                      //                   widget.products['sellerUid']);
                      //     },
                      //     icon: context
                      //                 .watch<WishListProvider>()
                      //                 .getWishItems
                      //                 .firstWhereOrNull((wish) =>
                      //                     wish.documentId ==
                      //                     widget.products['productId']) !=
                      //             null
                      //         ? Icon(
                      //             Icons.favorite,
                      //             color: Colors.red,
                      //           )
                      //         : Icon(Icons.favorite_outline_outlined)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   left: 10,
          //   top: 10,
          //   child: Badge(
          //     toAnimate: true,
          //     animationType: BadgeAnimationType.fade,
          //     shape: BadgeShape.square,
          //     badgeColor: generalColor,
          //     borderRadius: BorderRadius.circular(10),
          //     badgeContent:
          //         Text('New Arrival', style: TextStyle(color: Colors.white)),
          //   ),
          // ),
        ],
      ),
    );
  }
}
