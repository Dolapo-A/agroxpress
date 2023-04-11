// import 'dart:js';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:agroxpresss/views/minor_screens/visit_store_screen.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorSearchScreen extends StatefulWidget {
  final dynamic products;
  const VendorSearchScreen({required this.products, Key? key})
      : super(key: key);

  @override
  State<VendorSearchScreen> createState() => _VendorSearchScreenState();
}

class _VendorSearchScreenState extends State<VendorSearchScreen> {
  // const SearchScreen({Key? key}) : super(key: key);
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.grey[700],
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: generalColor),
          title: CupertinoSearchTextField(
            autofocus: true,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
        ),
        body: searchInput == ''
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 100,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(fontSize: 22, color: Colors.grey[400]),
                    )
                  ],
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vendors')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  final searchResult = snapshot.data!.docs.where((e) {
                    return e['storeName']
                        .toLowerCase()
                        .contains(searchInput.toLowerCase());
                  });
                  return ListView(
                    children: searchResult.map((
                      e,
                    ) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VisitStoreScreen(vendorUid: e['vendorUid']),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5,
                                      color: Colors.grey
                                          .shade500)), // This will create top borders for the rest
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: e['image'],
                                      placeholder: (context, url) {
                                        return LinearProgressIndicator(
                                          minHeight: 2,
                                          backgroundColor:
                                              Color.fromARGB(77, 67, 115, 102),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color.fromARGB(
                                                      208, 67, 115, 102)),
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
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          e['storeName'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ));
  }
}
