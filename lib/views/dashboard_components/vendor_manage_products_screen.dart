import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/models/vendor_manage_products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/widget/products_model.dart';

class ManageProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sellerUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
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
            'Manage Products',
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                'This category has no item yet\n 😔',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 230,
                childAspectRatio: 3,
                mainAxisExtent: 250),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            // crossAxisCount: 2,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return VendorManageProductsModel(
                products: snapshot.data!.docs[index],
              );
            },
            // staggeredTileBuilder: (context) => StaggeredTile.fit(1)
          );
        },
      ),
    );
  }
}
