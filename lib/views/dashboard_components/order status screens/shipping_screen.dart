import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/models/vendor_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShippingScreen extends StatefulWidget {
  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Orders')
          .where('vendorUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('deliveryStatus', isEqualTo: 'shipping')
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

        if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'You have no orders currently in shipment',
            style: TextStyle(fontSize: 16),
          ));
        }

        return Scaffold(
          body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return VendorOrderModel(order: snapshot.data!.docs[index]);
              }),
        );
      },
    );
  }
}
