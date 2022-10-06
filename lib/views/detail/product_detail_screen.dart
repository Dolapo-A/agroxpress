// import 'dart:html';

// import 'dart:html';
import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/controllers/snack_bar_controller.dart';
import 'package:agroxpresss/models/product_model.dart';
import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:agroxpresss/provider/wishlist_provider.dart';
import 'package:agroxpresss/views/minor_screens/visit_store_screen.dart';
import 'package:agroxpresss/views/screens/cart_screen%20_product_details.dart';
import 'package:agroxpresss/views/screens/cart_screen.dart';
import 'package:agroxpresss/views/screens/widget/full_image_screen.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic productList;

  const ProductDetailScreen({Key? key, this.productList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> images = productList['productImage'];
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: productList['category'])
        .snapshots();
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
          toolbarHeight: 60,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.grey[700],
              )),
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
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Product Details',
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FullImageScreen(
                            imageList: images,
                          );
                        }));
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                          layout: SwiperLayout.DEFAULT,
                          indicatorLayout: PageIndicatorLayout.SCALE,
                          autoplay: false,
                          autoplayDelay: 15000,
                          autoplayDisableOnInteraction: true,
                          duration: 1000,
                          itemCount: images.length,
                          pagination: SwiperPagination(
                            builder: SwiperPagination.dots,
                          ),
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: images[index],
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
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //     bottom: -20,
                  //     child: Container(
                  //       height: 45,
                  //       // width: 40,
                  //       decoration: BoxDecoration(
                  //           color: Colors.grey.shade200,
                  //           borderRadius: BorderRadius.circular(50)),
                  //       child: Row(
                  //         children: [
                  //           IconButton(
                  //               onPressed: () {},
                  //               icon: Icon(FontAwesomeIcons.minus)),
                  //           Text('1'),
                  //           IconButton(
                  //               onPressed: () {},
                  //               icon: Icon(
                  //                 FontAwesomeIcons.plus,
                  //                 color: generalColor,
                  //               ))
                  //         ],
                  //       ),
                  //     )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                productList['productName'],
                style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 10,
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: getCurrency(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: productList['price'].toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '/Kg',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Provider.of<WishListProvider>(context, listen: false)
                                      .getWishItems
                                      .firstWhereOrNull((wish) =>
                                          wish.documentId ==
                                          productList['productId']) !=
                                  null
                              ? context
                                  .read<WishListProvider>()
                                  .removeWish(productList['productId'])
                              : Provider.of<WishListProvider>(context,
                                      listen: false)
                                  .addWishItem(
                                      productList['productName'],
                                      productList['price'],
                                      1,
                                      productList['inStock'],
                                      images,
                                      productList['productId'],
                                      productList['sellerUid']);
                        },
                        icon: context
                                    .watch<WishListProvider>()
                                    .getWishItems
                                    .firstWhereOrNull((wish) =>
                                        wish.documentId ==
                                        productList['productId']) !=
                                null
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_outline_outlined)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 10,
                    ),
                    child: productList['inStock'] == 0
                        ? Text(
                            'This item is out of stock',
                            style:
                                TextStyle(fontSize: 16, color: Colors.red[700]),
                          )
                        : Text(
                            '${productList['inStock']} KG available',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        'Item description',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\t\t' + productList['productDescription'],
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        'Similar products',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: generalColor,
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'This category has no item yet\n\n 😔',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      // crossAxisCount: 2,

                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        // crossAxisCount: 2,
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        mainAxisExtent: 250,
                        // crossAxisSpacing: 25,
                        // mainAxisSpacing: 20
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: ProductModel(
                            products: snapshot.data!.docs[index],
                          ),
                        );
                      },
                      // staggeredTileBuilder: (context) => StaggeredTile.fit(1)
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VisitStoreScreen(
                          vendorUid: productList['sellerUid'],
                        );
                      }));
                    },
                    icon: Icon(Icons.store)),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CartScreenProductDetails();
                    }));
                  },
                  icon: Badge(
                      showBadge:
                          Provider.of<CartProvider>(context).getItems.isEmpty
                              ? false
                              : true,
                      badgeColor: generalColor,
                      animationType: BadgeAnimationType.scale,
                      badgeContent: Text(
                        Provider.of<CartProvider>(context)
                            .getItems
                            .length
                            .toString(),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      child: Icon(Icons.shopping_cart)),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: generalColor, borderRadius: BorderRadius.circular(30)),
              child: MaterialButton(
                onPressed: () {
                  if (productList['inStock'] == 0) {
                    snackBar('This item is out of stock', context);
                  } else if (Provider.of<CartProvider>(context, listen: false)
                          .getItems
                          .firstWhereOrNull((cart) =>
                              cart.documentId == productList['productId']) !=
                      null) {
                    // snackBar('Item already exists in cart', context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CartScreenProductDetails();
                    }));
                  } else {
                    Provider.of<CartProvider>(context, listen: false).addItem(
                        productList['productName'],
                        productList['price'],
                        1,
                        productList['inStock'],
                        images,
                        productList['productId'],
                        productList['sellerUid']);
                  }
                },
                child: Text(
                  'Add to cart',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
