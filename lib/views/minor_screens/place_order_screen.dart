import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:agroxpresss/views/minor_screens/payment_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatelessWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference customer =
        FirebaseFirestore.instance.collection('customers');

    return FutureBuilder(
        future: customer.doc(auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong, unable to fetch data'));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text('Data does not exist');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return SafeArea(
              child: Scaffold(
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
                      'Place Order',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Name: ${data['fullName']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Address: ${data['address']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Phone: ${data['phone']}',
                                  style: TextStyle(fontSize: 16),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Consumer<CartProvider>(
                                builder: (context, CartProvider, child) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: CartProvider.count,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0, top: 10),
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(children: [
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: CartProvider
                                                    .getItems[index]
                                                    .imagesUrl[0],
                                                placeholder: (context, url) {
                                                  return LinearProgressIndicator(
                                                    minHeight: 2,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            77, 67, 115, 102),
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color.fromARGB(208,
                                                                67, 115, 102)),
                                                  );
                                                  // return Icon(Icons.home);
                                                },
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Icon(
                                                    Icons
                                                        .image_not_supported_rounded,
                                                    color: Colors.grey[400],
                                                  );
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    CartProvider
                                                        .getItems[index].name,
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: 'GHS ',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            TextSpan(
                                                              text: CartProvider
                                                                  .getItems[
                                                                      index]
                                                                  .price
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 110,
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .multiply,
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: CartProvider
                                                                  .getItems[
                                                                      index]
                                                                  .quantity
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: '/KG',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    );
                                  });
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.90,
                        decoration: BoxDecoration(
                            color: generalColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PaymentScreen();
                            }));
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Material(
            child: Center(
                child: CircularProgressIndicator(
              color: generalColor,
            )),
          );
        });
  }
}
