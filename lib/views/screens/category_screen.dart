// import 'package:agroxpresss/const.dart';
// import 'package:agroxpresss/views/categories/grains_category_screen.dart';
// import 'package:flutter/material.dart';

// class CategoryScreen extends StatefulWidget {
//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   final PageController _pageController = PageController();
//   List<ItemData> _item = [
//     ItemData(categoryName: 'Grains'),
//     ItemData(categoryName: 'Fruits\n and\n vegetables\n'),
//     ItemData(categoryName: 'Tuber\n crops'),
//     ItemData(categoryName: 'Protein'),
//   ];

//   // const CategoryScreen({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.8,
//               width: MediaQuery.of(context).size.width * 0.2,
//               color: Colors.white,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: _item.length,
//                 itemBuilder: (BuildContext context, index) {
//                   return GestureDetector(
//                       onTap: () {
//                         _pageController.jumpToPage(index);
//                         // for (var element in _item) {
//                         //   element.isSelected = false;
//                         // }
//                         // setState(() {
//                         //   _item[index].isSelected = true;
//                         // });
//                       },
//                       child: Container(
//                         color: _item[index].isSelected == true
//                             ? Colors.grey.shade200
//                             : Colors.transparent,
//                         height: 100,
//                         child: Center(
//                           child: Text(_item[index].categoryName,
//                               style: TextStyle(
//                                 fontSize: 14,
//                               )),
//                         ),
//                       ));
//                 },
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.8,
//               width: MediaQuery.of(context).size.width * 0.80,
//               color: Colors.grey.shade200,
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (value) {
//                   for (var element in _item) {
//                     element.isSelected = false;
//                   }
//                   setState(() {
//                     _item[value].isSelected = true;
//                   });
//                 },
//                 scrollDirection: Axis.vertical,
//                 children: [
//                   GrainsCategoryScreen(),
//                   Center(
//                     child: Text('Fruits and Vegetables'),
//                   ),
//                   Center(
//                     child: Text('Tuber crops'),
//                   ),
//                   Center(
//                     child: Text('Protein'),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class ItemData {
//   String categoryName;
//   bool isSelected;

//   ItemData({required this.categoryName, this.isSelected = false});
// }

// import 'dart:js';

import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorySearchScreen extends StatefulWidget {
  final dynamic products;
  const CategorySearchScreen({required this.products, Key? key})
      : super(key: key);

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreen();
}

class _CategorySearchScreen extends State<CategorySearchScreen> {
  // const CategorySearchScreen({Key? key}) : super(key: key);
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 60,
          bottom: PreferredSize(
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
          iconTheme: IconThemeData(color: generalColor),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 500),
              child: Container(color: Colors.transparent),
            ),
          ),
          title: CupertinoSearchTextField(
            autofocus: false,
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
                    .collection('products')
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
                    return e['productName']
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
                                  builder: (context) => ProductDetailScreen(
                                        productList: e,
                                      )));
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
                                  Stack(children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: e['productImage'][0],
                                        placeholder: (context, url) {
                                          return LinearProgressIndicator(
                                            minHeight: 2,
                                            backgroundColor: Color.fromARGB(
                                                77, 67, 115, 102),
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
                                    e['discount'] != 0
                                        ? Positioned(
                                            left: 0,
                                            top: 5,
                                            child: Container(
                                              height: 20,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: generalColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5))),
                                              child: Center(
                                                child: Text(
                                                  'Save ${e['discount'].toString()} %',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.transparent,
                                          ),
                                    Positioned(
                                      left: 0,
                                      top: 5,
                                      child: e['inStock'] == 0
                                          ? Container(
                                              height: 20,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5))),
                                              child: Center(
                                                child: Text(
                                                  'Out of Stock',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color: Colors.transparent,
                                            ),
                                    ),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          e['productName'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        RichText(
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: getCurrency(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: e['price'].toString(),
                                              style: e['discount'] != 0
                                                  ? TextStyle(
                                                      color: Colors.grey,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : TextStyle(
                                                      color: Colors.black,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          TextSpan(text: ' '),
                                          e['discount'] != 0
                                              ? TextSpan(
                                                  text: ((1 -
                                                              (e['discount'] /
                                                                  100)) *
                                                          e['price'])
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold))
                                              : TextSpan(),
                                          TextSpan(
                                            text: '/KG',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ])),
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
