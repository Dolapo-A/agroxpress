import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreparingScreen extends StatefulWidget {
  @override
  _PreparingScreenState createState() => _PreparingScreenState();
}

class _PreparingScreenState extends State<PreparingScreen> {
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Orders')
          .where('deliveryStatus', isEqualTo: 'preparing')
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
                            height: 100,
                            width: 100,
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
                                  Text(
                                    'Name:  ${order['customerName']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Email:  ${order['email']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Phone:  ${order['phone']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Address:  ${order['address']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Payment Type: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${order['paymentStatus']}*',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Delivery Status:  ${order['deliveryStatus']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text(order[])
                                  //   ],
                                  // )
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Order date: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: DateFormat('dd-MM-yyyy').format(
                                              order['orderDate'].toDate()),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
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
