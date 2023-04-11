import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/models/vendor_order_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          .where('vendorUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

        if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'You have no active orders that need to be attended to',
            textAlign: TextAlign.center,
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