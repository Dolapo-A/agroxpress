import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/alert_dialog.dart';
import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:agroxpresss/views/minor_screens/place_order_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../provider/wishlist_provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cartScreen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 500),
            child: Container(color: Colors.transparent),
          ),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          context.watch<CartProvider>().getItems.isEmpty
              ? SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDilaog.showMyDialog(
                        context: context,
                        title: 'Clear Cart',
                        content: 'Do you want to clear your cart?',
                        tabNo: () {
                          Navigator.pop(context);
                        },
                        tabYes: () {
                          context.read<CartProvider>().clearcart();
                          Navigator.pop(context);
                        });
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ),
                )
        ],
      ),
      body: context.watch<CartProvider>().getItems.isNotEmpty
          ? Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 65),
                  child: ListView.builder(
                      itemCount: cartProvider.count,
                      itemBuilder: (context, index) {
                        final product = cartProvider.getItems[index];
                        return Card(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: cartProvider
                                            .getItems[index].imagesUrl[0]
                                            .toString(),
                                        placeholder: (context, url) {
                                          return LinearProgressIndicator(
                                            minHeight: 2,
                                            backgroundColor: Color.fromARGB(
                                                77, 67, 115, 102),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color.fromARGB(
                                                        208, 67, 115, 102)),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Icon(
                                            Icons.image_not_supported_rounded,
                                            color: Colors.grey[400],
                                            size: 20,
                                          );
                                        })),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          cartProvider.getItems[index].name,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'GHS ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: cartProvider
                                                        .getItems[index].price
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 35,
                                              // width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Row(
                                                children: [
                                                  cartProvider.getItems[index]
                                                              .quantity ==
                                                          1
                                                      ? IconButton(
                                                          onPressed: () {
                                                            showCupertinoModalPopup<
                                                                void>(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  CupertinoActionSheet(
                                                                title: const Text(
                                                                    'RemoveItem'),
                                                                message: const Text(
                                                                    'Are you sure you want to remove this item?'),
                                                                actions: <
                                                                    CupertinoActionSheetAction>[
                                                                  CupertinoActionSheetAction(
                                                                    /// This parameter indicates the action would be a default
                                                                    /// defualt behavior, turns the action's text to bold text.
                                                                    isDefaultAction:
                                                                        true,
                                                                    onPressed:
                                                                        () async {
                                                                      Provider.of<WishListProvider>(context, listen: false).getWishItems.firstWhereOrNull((element) => element.documentId == product.documentId) !=
                                                                              null
                                                                          ? context.read<CartProvider>().removeItem(
                                                                              product)
                                                                          : await context.read<WishListProvider>().addWishItem(
                                                                              product.name,
                                                                              product.price,
                                                                              1,
                                                                              product.quantity,
                                                                              product.imagesUrl,
                                                                              product.documentId,
                                                                              product.sellerUid,
                                                                              product.category);

                                                                      context
                                                                          .read<
                                                                              CartProvider>()
                                                                          .removeItem(
                                                                              product);

                                                                      Navigator.pop(
                                                                          context);
                                                                    },

                                                                    child: const Text(
                                                                        'Move to wishlist'),
                                                                  ),
                                                                  CupertinoActionSheetAction(
                                                                    onPressed:
                                                                        () {
                                                                      cartProvider
                                                                          .removeItem(
                                                                              cartProvider.getItems[index]);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'Delete Item'),
                                                                  ),
                                                                ],
                                                                cancelButton:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.red),
                                                                        )),
                                                              ),
                                                            );
                                                          },
                                                          icon: Icon(
                                                              FontAwesomeIcons
                                                                  .trash),
                                                          iconSize: 16,
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            cartProvider.decreament(
                                                                cartProvider
                                                                        .getItems[
                                                                    index]);
                                                          },
                                                          icon: Icon(
                                                              FontAwesomeIcons
                                                                  .minus)),
                                                  // IconButton(
                                                  //   onPressed: cartProvider
                                                  //               .getItems[index]
                                                  //               .quantity ==
                                                  //           1
                                                  //       ? null
                                                  //       : () {
                                                  //           cartProvider.decreament(
                                                  //               cartProvider
                                                  //                       .getItems[
                                                  //                   index]);
                                                  //         },
                                                  //   icon: Icon(
                                                  //       FontAwesomeIcons.trash),
                                                  //   iconSize: 20,
                                                  // ),
                                                  Text(cartProvider
                                                      .getItems[index].quantity
                                                      .toString()),
                                                  IconButton(
                                                    onPressed: cartProvider
                                                                .getItems[index]
                                                                .quantity ==
                                                            cartProvider
                                                                .getItems[index]
                                                                .inStock
                                                        ? null
                                                        : () {
                                                            cartProvider.increament(
                                                                cartProvider
                                                                        .getItems[
                                                                    index]);
                                                          },
                                                    icon: Icon(
                                                        FontAwesomeIcons.plus),
                                                    iconSize: 20,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/icons/empty_box2.png'))),
                  ),
                  // SizedBox(
                  //   height: 1,
                  // ),
                  // Material(
                  //   color: generalColor,
                  //   borderRadius: BorderRadius.circular(10),
                  //   child: MaterialButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       'continue shopping',
                  //       style: TextStyle(fontSize: 16, color: Colors.white),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Total:  ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'GHS ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: Provider.of<CartProvider>(context)
                            .totalPrice
                            .toStringAsFixed(2)
                            .toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: generalColor, borderRadius: BorderRadius.circular(30)),
              child: MaterialButton(
                onPressed: context.watch<CartProvider>().totalPrice == 0.00
                    ? null
                    : () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PlaceOrderScreen();
                        }));
                      },
                child: Text(
                  'CHECK OUT',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
