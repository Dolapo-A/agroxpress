// import 'dart:html';

import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:agroxpresss/views/minor_screens/visit_store_screen.dart';
import 'package:agroxpresss/views/screens/widget/full_image_screen.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

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
          toolbarHeight: 80,
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
            style: TextStyle(color: Colors.black, fontSize: 24),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    autoplay: true,
                    autoplayDelay: 15000,
                    autoplayDisableOnInteraction: true,
                    duration: 1000,
                    itemCount: images.length,
                    pagination: SwiperPagination(
                      builder: SwiperPagination.dots,
                    ),
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                productList['productName'],
                style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 10,
                  top: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'GHC  ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          productList['price'].toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_outline_outlined)),
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
                    child: Text(
                      '${productList['inStock']} piece(s) available in stock',
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
                    padding: const EdgeInsets.only(bottom: 50.0),
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
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: generalColor, borderRadius: BorderRadius.circular(10)),
              child: MaterialButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addItem(
                      productList['productName'],
                      productList['price'],
                      1,
                      productList['inStock'],
                      images,
                      productList['productId'],
                      productList['sellerUid']);
                },
                child: Text(
                  'ADD TO CART',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
