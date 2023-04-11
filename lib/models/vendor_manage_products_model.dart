import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/provider/wishlist_provider.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class VendorManageProductsModel extends StatefulWidget {
  final dynamic products;
  const VendorManageProductsModel({required this.products, Key? key})
      : super(key: key);

  @override
  State<VendorManageProductsModel> createState() =>
      _VendorManageProductsModel();
}

class _VendorManageProductsModel extends State<VendorManageProductsModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
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
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Text(
                    widget.products['productName'],
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 2,
                        ),
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
                SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 0.0),
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
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold),
                          ),
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit_rounded,
                            color: Colors.grey,
                            size: 22,
                          )),
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
                        'Save ${widget.products['discount'].toString()} %',
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
    );
  }
}
