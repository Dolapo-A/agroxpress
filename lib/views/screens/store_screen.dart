import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/inner_screens/vendors_search_screen.dart';
import 'package:agroxpresss/views/minor_screens/visit_store_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80,
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
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext builder) {
                return VendorSearchScreen(
                  products: required,
                );
              }));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Stores',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Search Stores',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('vendors').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 1,
                //   mainAxisExtent: 240,

                //   // crossAxisSpacing: 25,
                //   // mainAxisSpacing: 20
                // ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500,
                    // childAspectRatio: 1 / 5,
                    mainAxisExtent: 230),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VisitStoreScreen(
                            vendorUid: snapshot.data!.docs[index]['vendorUid']);
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(59, 21, 21, 21),
                                  spreadRadius: 1,
                                  blurRadius: 40,
                                  offset: Offset(0, 5))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              child: SizedBox(
                                height: 140,
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot.data!.docs[index]
                                        ['image'],
                                    placeholder: (context, url) {
                                      return LinearProgressIndicator(
                                        minHeight: 2,
                                        backgroundColor:
                                            Color.fromARGB(77, 67, 115, 102),
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(208, 67, 115, 102)),
                                      );
                                      // return Icon(Icons.home);
                                    },
                                    errorWidget: (context, url, error) {
                                      return Icon(
                                        Icons.image_not_supported_rounded,
                                        color: Colors.grey[400],
                                        size: 40,
                                      );
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 20, bottom: 20),
                              child: Text(
                                snapshot.data!.docs[index]['storeName'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }

          return Center(
            child: Text(
              'No Stores available at the moment',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
