import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class fruitsandVegetablesScreen extends StatefulWidget {
  const fruitsandVegetablesScreen({Key? key}) : super(key: key);

  @override
  State<fruitsandVegetablesScreen> createState() =>
      _fruitsandVegetablesGalleryScreenState();
}

class _fruitsandVegetablesGalleryScreenState
    extends State<fruitsandVegetablesScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: 'Fruits and Vegetables')
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
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 230,
              childAspectRatio: 3,
              mainAxisExtent: 240),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          // crossAxisCount: 2,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return ProductModel(
              products: snapshot.data!.docs[index],
            );
          },
          // staggeredTileBuilder: (context) => StaggeredTile.fit(1)
        );
      },
    );
  }
}
