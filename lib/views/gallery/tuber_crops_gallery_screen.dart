import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class tuberCropsScreen extends StatefulWidget {
  const tuberCropsScreen({Key? key}) : super(key: key);

  @override
  State<tuberCropsScreen> createState() => _tuberCropsScreenState();
}

class _tuberCropsScreenState extends State<tuberCropsScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: 'Tuber Crops')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
              'This category has no item yet\n\n 😔',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 230,
              childAspectRatio: 3,
              mainAxisExtent: 250),
          // crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return ProductModel(
              products: snapshot.data!.docs[index],
            );
          },
          // staggeredTileBuilder: (context) => StaggeredTile.fit(1)
        );

        // ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> data =
        //         document.data()! as Map<String, dynamic>;
        //     return ListTile(
        //       title: Text(data['productName']),
        //       // subtitle: Text(data['price'.toString()]),
        //     );
        //   }).toList(),
        // );
      },
    );
  }
}
