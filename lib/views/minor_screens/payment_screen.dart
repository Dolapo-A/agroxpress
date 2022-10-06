import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:agroxpresss/views/minor_screens/payment_screen.dart';
import 'package:agroxpresss/views/screens/customer_home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedItem = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String orderId;

  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
      max: 100, msg: 'Please wait',
      // barrierColor: Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = Provider.of<CartProvider>(context).totalPrice;
    double totalPaid = Provider.of<CartProvider>(context).totalPrice + 20;
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
                      'Confirmation',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    )),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: getCurrency(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: totalPrice.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey.shade500,
                                  thickness: 0.5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Delivery fee',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: getCurrency(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: '20',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Total Paid ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '(Delivery fee included)',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: getCurrency(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: totalPaid.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedItem,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedItem = value!;
                                  });
                                },
                                title: Text('Payment on delivery'),
                                subtitle:
                                    Text('Pay when the rider/driver arrives'),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedItem,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedItem = value!;
                                  });
                                },
                                title: Text('Mobile money'),
                                subtitle: Text(
                                    'Pay using either MTN, Vodafone or airtelTigo'),
                              ),
                              RadioListTile(
                                value: 3,
                                groupValue: selectedItem,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedItem = value!;
                                  });
                                },
                                title: Text('Pay with Card'),
                                subtitle:
                                    Text('Pay using either Visa or Mastercard'),
                              ),
                              RadioListTile(
                                value: 4,
                                groupValue: selectedItem,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedItem = value!;
                                  });
                                },
                                title: Text('Pay with Stripe'),
                              ),
                            ],
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
                            if (selectedItem == 1) {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Payment from anywhere(in Ghana)',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              decoration: BoxDecoration(
                                                  color: generalColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  showProgress();
                                                  for (var item in context
                                                      .read<CartProvider>()
                                                      .getItems) {
                                                    CollectionReference
                                                        orderRef =
                                                        _firestore.collection(
                                                            'Orders');
                                                    orderId = Uuid().v4();
                                                    await orderRef
                                                        .doc(orderId)
                                                        .set({
                                                      'customerId': data['cid'],
                                                      'customerName':
                                                          data['fullName'],
                                                      'phone': data['phone'],
                                                      'email': data['email'],
                                                      'address':
                                                          data['address'],
                                                      'profileImage':
                                                          data['image'],
                                                      'vendorUid':
                                                          item.sellerUid,
                                                      'productId':
                                                          item.documentId,
                                                      'orderId': orderId,
                                                      'orderName': item.name,
                                                      'orderImage':
                                                          item.imagesUrl.first,
                                                      'orderQuantity':
                                                          item.quantity,
                                                      'orderPrice':
                                                          item.quantity *
                                                              item.price,
                                                      'deliveryStatus':
                                                          'preparing',
                                                      'deliveryDate': '',
                                                      'orderDate':
                                                          DateTime.now(),
                                                      'paymentStatus':
                                                          'Payment on delivery',
                                                      'orderReview': false,
                                                    }).whenComplete(() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .runTransaction(
                                                              (transaction) async {
                                                        DocumentReference
                                                            documentReference =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .doc(item
                                                                    .documentId);
                                                        DocumentSnapshot
                                                            snapshot2 =
                                                            await transaction.get(
                                                                documentReference);

                                                        transaction.update(
                                                            documentReference, {
                                                          'inStock': snapshot2[
                                                                  'inStock'] -
                                                              item.quantity
                                                        });
                                                      });
                                                    });
                                                  }
                                                  context
                                                      .read<CartProvider>()
                                                      .clearcart();
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          CustomerHomeScreen
                                                              .routeName,
                                                          (route) => false);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Pay',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                          child: Text(
                            'Confirm  ${totalPaid.toStringAsFixed(2)}',
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
