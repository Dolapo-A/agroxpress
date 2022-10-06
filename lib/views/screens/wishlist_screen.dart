import 'dart:ui';

import 'package:agroxpresss/controllers/alert_dialog.dart';
import 'package:agroxpresss/provider/wishlist_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const String routeName = 'cartScreen';

  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey[700],
            )),
        toolbarHeight: 80,
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
          'Wishlist',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          context.watch<WishListProvider>().getWishItems.isEmpty
              ? SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDilaog.showMyDialog(
                        context: context,
                        title: 'Clear Wishlist',
                        content: 'Do you want to clear your wishlist?',
                        tabNo: () {
                          Navigator.pop(context);
                        },
                        tabYes: () {
                          context.read<WishListProvider>().clearwish();
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
      body: context.watch<WishListProvider>().getWishItems.isNotEmpty
          ? Consumer<WishListProvider>(
              builder: (context, wishProvider, child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 65),
                  child: ListView.builder(
                      itemCount: wishProvider.count,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: wishProvider
                                            .getWishItems[index].imagesUrl[0]
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
                                          wishProvider.getWishItems[index].name,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text(
                                            //   cartProvider.getItems[index].price
                                            //       .toStringAsFixed(2),
                                            //   style: TextStyle(
                                            //     color: Colors.black,
                                            //     fontSize: 18,
                                            //   ),
                                            // ),
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'GHC  ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: wishProvider
                                                        .getWishItems[index]
                                                        .price
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                // height: 40,
                                                // width: 40,
                                                decoration: BoxDecoration(
                                                    // color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  WishListProvider>()
                                                              .removeWishItem(
                                                                  wishProvider
                                                                          .getWishItems[
                                                                      index]);
                                                        },
                                                        icon: Icon(Icons
                                                            .remove_circle_outline)),
                                                    IconButton(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  WishListProvider>()
                                                              .removeWishItem(
                                                                  wishProvider
                                                                          .getWishItems[
                                                                      index]);
                                                        },
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .cartArrowDown,
                                                          size: 20,
                                                        ))
                                                  ],
                                                ))
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
              child: Text(
                'You have no item in your wishlist',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}
