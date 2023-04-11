import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class VendorOrderModel extends StatelessWidget {
  final dynamic order;
  const VendorOrderModel({Key? key, required this.order}) : super(key: key);
  // final Stream<QuerySnapshot> _usersStream =
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
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
                      backgroundColor: Color.fromARGB(77, 67, 115, 102),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  text: order['orderPrice'].toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Quantity:  ' + order['orderQuantity'].toString(),
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
              // width: double.infinity,
              decoration: BoxDecoration(color: generalColor.withOpacity(0.0)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:  ${order['customerName']}',
                        style: TextStyle(fontSize: 14),
                      ),
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
                                fontSize: 14,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat('dd-MM-yyyy')
                                  .format(order['orderDate'].toDate()),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      order['deliveryStatus'] == 'delivered'
                          ? const Text('This order has been delivered')
                          : Row(children: [
                              const Text(
                                'Change delivery Status to: ',
                                style: TextStyle(fontSize: 14),
                              ),
                              order['deliveryStatus'] == 'preparing'
                                  ? TextButton(
                                      style: TextButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap),
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime.now()
                                                .add(const Duration(days: 365)),
                                            onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection('Orders')
                                              .doc(order['orderId'])
                                              .update({
                                            'deliveryStatus': 'shipping',
                                            'deliveryDate': date
                                          });
                                        });
                                      },
                                      child: const Text('shipping ?'))
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Orders')
                                            .doc(order['orderId'])
                                            .update({
                                          'deliveryStatus': 'delivered',
                                        });
                                      },
                                      child: const Text('delivered ?'))
                            ]),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
