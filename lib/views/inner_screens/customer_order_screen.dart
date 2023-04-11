import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CustomerOrderScreen extends StatefulWidget {
  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  late double rate;
  late String comment;
  // final Stream<QuerySnapshot> _usersStream =
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Orders')
          .where('customerId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
                child: CircularProgressIndicator(
              color: generalColor,
            )),
          );
        }

        return Scaffold(
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
                'Orders',
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
          body: ListView.builder(
              // shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var order = snapshot.data!.docs[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10),
                    child: ExpansionTile(
                      textColor: Colors.black,
                      iconColor: generalColor,
                      tilePadding: EdgeInsets.only(right: 10, left: 10),
                      title: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: order['orderImage'].toString(),
                              placeholder: (context, url) {
                                return LinearProgressIndicator(
                                  minHeight: 2,
                                  backgroundColor:
                                      Color.fromARGB(77, 67, 115, 102),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(208, 67, 115, 102)),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Icon(
                                  Icons.image_not_supported_rounded,
                                  color: Colors.grey[400],
                                );
                              },
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order['orderName'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: getCurrency(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: order['orderPrice']
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Quantity:  ' +
                                            order['orderQuantity'].toString(),
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'see more...',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(order['deliveryStatus'])
                        ],
                      ),
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: generalColor.withOpacity(0.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'Name:  ${order['customerName']}',
                                  //   style: TextStyle(fontSize: 16),
                                  // ),
                                  Text(
                                    'Email:  ${order['email']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Phone:  ${order['phone']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Address:  ${order['address']}',
                                    style: TextStyle(fontSize: 14),
                                  ),

                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Payment Type: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${order['paymentStatus']}*',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Delivery Status:  ${order['deliveryStatus']}',
                                    style: TextStyle(fontSize: 14),
                                  ),

                                  order['deliveryStatus'] == 'preparing' ||
                                          order['deliveryStatus'] == 'shipping'
                                      ? Text(
                                          'Estimated Delivery Date: ' +
                                              (DateFormat('dd-MM-yyyy')
                                                  .format(order['deliveryDate']
                                                      .toDate())
                                                  .toString()),
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Container(),

                                  order['deliveryStatus'] == 'delivered' &&
                                          order['orderReview'] == false
                                      ? TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Material(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 20.0,
                                                              bottom: 20.0,
                                                              top: 40),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            RatingBar.builder(
                                                                initialRating:
                                                                    1,
                                                                glow: false,
                                                                minRating: 0.5,
                                                                allowHalfRating:
                                                                    true,
                                                                itemBuilder:
                                                                    (context,
                                                                        _) {
                                                                  return Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .amberAccent);
                                                                },
                                                                onRatingUpdate:
                                                                    (value) {
                                                                  rate = value;
                                                                }),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            TextField(
                                                              maxLines: 6,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'Enter your review',
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              generalColor,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              generalColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                comment = value;
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  height: 50,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.40,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          generalColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      MaterialButton(
                                                                    onPressed:
                                                                        () async {
                                                                      CollectionReference collRef = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'products')
                                                                          .doc(order[
                                                                              'productId'])
                                                                          .collection(
                                                                              'reviews');

                                                                      await collRef
                                                                          .doc(FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid)
                                                                          .set({
                                                                        'name':
                                                                            order['customerName'],
                                                                        'email':
                                                                            order['email'],
                                                                        'rate':
                                                                            rate,
                                                                        'comment':
                                                                            comment,
                                                                        'profileImage':
                                                                            order['profileImage'],
                                                                      }).whenComplete(
                                                                              () async {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .runTransaction((transaction) async {
                                                                          DocumentReference
                                                                              documentReference =
                                                                              FirebaseFirestore.instance.collection('Orders').doc(order['orderId']);

                                                                          transaction.update(
                                                                              documentReference,
                                                                              {
                                                                                'orderReview': true,
                                                                              });
                                                                        });
                                                                      });

                                                                      await Future.delayed(const Duration(
                                                                              microseconds:
                                                                                  100))
                                                                          .whenComplete(() =>
                                                                              Navigator.pop(context));
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Submit',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.40,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                        context,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
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
                                          child: const Text('Write review'))
                                      : Container(),
                                  // ? RichText(
                                  //     text: TextSpan(children: <TextSpan>[
                                  //     TextSpan(
                                  //       text: 'Write Review',
                                  //       style: TextStyle(
                                  //           color: Color(0xff437366),
                                  //           fontSize: 14),
                                  //     ),
                                  //   ]))
                                  // : Container(),
                                  order['deliveryStatus'] == 'delivered' &&
                                          order['orderReview'] == true
                                      ? Row(
                                          children: [
                                            Text(
                                              'Review added',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              FontAwesomeIcons.checkCircle,
                                              size: 25,
                                              color: generalColor,
                                            )
                                          ],
                                        )
                                      : Container(),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
