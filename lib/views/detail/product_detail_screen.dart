// import 'dart:html';

// import 'dart:html';
import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:agroxpresss/provider/wishlist_provider.dart';
import 'package:agroxpresss/views/minor_screens/visit_store_screen.dart';
import 'package:agroxpresss/views/screens/cart_screen%20_product_details.dart';
import 'package:agroxpresss/views/screens/widget/full_image_screen.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productList;

  const ProductDetailScreen({Key? key, this.productList}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.productList['discount'];
    int itemQty = 1;
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    final TextEditingController quantityy = TextEditingController();
    List<dynamic> images = widget.productList['productImage'];
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.productList['category'])
        .snapshots();

    final Stream<QuerySnapshot> reviewStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productList['productId'])
        .collection('reviews')
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
                widget.productList['productName'],
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
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: widget.productList['price'].toString(),
                              style: onSale != 0
                                  ? TextStyle(
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                          TextSpan(text: '  '),
                          onSale != 0
                              ? TextSpan(
                                  text: ((1 -
                                              (widget.productList['discount'] /
                                                  100)) *
                                          widget.productList['price'])
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                              : TextSpan(),
                          TextSpan(
                            text: '/KG',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                        // RichText(
                        //     text: TextSpan(children: <TextSpan>[
                        //   TextSpan(
                        //       text: getCurrency(),
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold)),
                        //   TextSpan(
                        //     text: widget.productList['price'].toString(),
                        //     style: TextStyle(
                        //         fontSize: 16,
                        //         color: Colors.black,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        //   TextSpan(
                        //     text: '/Kg',
                        //     style: TextStyle(
                        //         fontSize: 16,
                        //         color: Colors.grey,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ])),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Provider.of<WishListProvider>(context, listen: false)
                                      .getWishItems
                                      .firstWhereOrNull((wish) =>
                                          wish.documentId ==
                                          widget.productList['productId']) !=
                                  null
                              ? context
                                  .read<WishListProvider>()
                                  .removeWish(widget.productList['productId'])
                              : Provider.of<WishListProvider>(context,
                                      listen: false)
                                  .addWishItem(
                                  widget.productList['productName'],
                                  onSale != 0
                                      ? ((1 -
                                              (widget.productList['discount'] /
                                                  100)) *
                                          widget.productList['price'])
                                      : widget.productList['price'],
                                  1,
                                  widget.productList['inStock'],
                                  images,
                                  widget.productList['productId'],
                                  widget.productList['sellerUid'],
                                  widget.productList['category'],
                                );
                        },
                        icon: context
                                    .watch<WishListProvider>()
                                    .getWishItems
                                    .firstWhereOrNull((wish) =>
                                        wish.documentId ==
                                        widget.productList['productId']) !=
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
                    child: widget.productList['inStock'] == 0
                        ? Text(
                            'This item is out of stock!',
                            style:
                                TextStyle(fontSize: 18, color: Colors.red[700]),
                          )
                        : Text(
                            '${widget.productList['inStock']} KG available',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 40,
                    //   width: 80,
                    //   child: Divider(
                    //     color: Colors.grey,
                    //     thickness: 1,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        'Item description',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // SizedBox(
                    //   height: 40,
                    //   width: 80,
                    //   child: Divider(
                    //     color: Colors.grey,
                    //     thickness: 1,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\t\t' + widget.productList['productDescription'],
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 20.0),
                child: ExpandableTheme(
                    data: ExpandableThemeData(iconColor: generalColor),
                    child: reviews(reviewStream)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 40,
                    //   width: 80,
                    //   child: Divider(
                    //     color: Colors.grey,
                    //     thickness: 1,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        'Similar products',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // SizedBox(
                    //   height: 40,
                    //   width: 80,
                    //   child: Divider(
                    //     color: Colors.grey,
                    //     thickness: 1,
                    //   ),
                    // ),
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

                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 230,
                        childAspectRatio: 3,
                        mainAxisExtent: 250,
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
                          vendorUid: widget.productList['sellerUid'],
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
            widget.productList['inStock'] == 0
                ? SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: generalColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Out of Stock !',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: generalColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  decoration: BoxDecoration(),
                                  child: Form(
                                    key: _formkey,
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Quantity/KG',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: TextFormField(
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    itemQty = int.parse(value);
                                                  });
                                                },
                                                autofocus: true,
                                                controller: quantityy,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                decoration: InputDecoration(
                                                  labelText: "Quantity/KG",
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 10,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xff437366),
                                                            width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  labelStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),

                                                  //for the errors
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.red,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                                validator: (
                                                  value,
                                                ) {
                                                  if (value!.isEmpty) {
                                                    return 'This field is required';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              decoration: BoxDecoration(
                                                  color: generalColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    Navigator.pop(context);
                                                    if (itemQty <= 0) {
                                                      // snackBar('This item is out of stock', context);
                                                      Flushbar(
                                                        flushbarPosition:
                                                            FlushbarPosition
                                                                .TOP,
                                                        margin: EdgeInsets.only(
                                                            left: 8,
                                                            right: 8,
                                                            top: 20,
                                                            bottom: 50),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        title: 'Invalid Input',
                                                        message:
                                                            "Enter a quantity greater than or equal " +
                                                                '${widget.productList['inStock']}/KG',
                                                        duration: Duration(
                                                            seconds: 10),
                                                        leftBarIndicatorColor:
                                                            Colors.red,
                                                      )..show(context);
                                                    } else if (Provider.of<
                                                                    CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .getItems
                                                            .firstWhereOrNull((cart) =>
                                                                cart.documentId ==
                                                                widget.productList[
                                                                    'productId']) !=
                                                        null) {
                                                    } else {
                                                      if (itemQty <=
                                                          widget.productList[
                                                              'inStock']) {
                                                        Provider.of<CartProvider>(context, listen: false).addItem(
                                                            widget.productList[
                                                                'productName'],
                                                            onSale != 0
                                                                ? ((1 -
                                                                        (widget.productList['discount'] /
                                                                            100)) *
                                                                    widget.productList[
                                                                        'price'])
                                                                : widget.productList[
                                                                    'price'],
                                                            itemQty,
                                                            widget.productList[
                                                                'inStock'],
                                                            images,
                                                            widget.productList[
                                                                'productId'],
                                                            widget.productList[
                                                                'sellerUid'],
                                                            widget.productList[
                                                                'category']);

                                                        Flushbar(
                                                          flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8,
                                                                  top: 0,
                                                                  bottom: 50),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          message:
                                                              "Item added to cart",
                                                          duration: Duration(
                                                              seconds: 10),
                                                          leftBarIndicatorColor:
                                                              generalColor,
                                                        )..show(context);
                                                      } else {
                                                        Flushbar(
                                                          flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8,
                                                                  top: 20,
                                                                  bottom: 50),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          title:
                                                              'Invalid Input',
                                                          message:
                                                              "Enter a quantity less than or equal to " +
                                                                  '${widget.productList['inStock']}/KG',
                                                          duration: Duration(
                                                              seconds: 10),
                                                          leftBarIndicatorColor:
                                                              Colors.red,
                                                        )..show(context);
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Confirm',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
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

Widget reviews(var reviewStream) {
  return ExpandablePanel(
      header: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          'Reviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      collapsed: SizedBox(
        height: 60,
        child: reviewsAll(reviewStream),
      ),
      expanded: reviewsAll(reviewStream));
}

Widget reviewsAll(var reviewStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot2.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(
            color: generalColor,
          ),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'This item has no review yet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }

      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot2.data!.docs[index]['profileImage'])),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot2.data!.docs[index]['name']),
                  Row(
                    children: [
                      Text(snapshot2.data!.docs[index]['rate'].toString()),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  )
                ],
              ),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
            );
          });
    },
  );
}
