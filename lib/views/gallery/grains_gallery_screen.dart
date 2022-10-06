import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class grainsGalleryScreen extends StatefulWidget {
  const grainsGalleryScreen({Key? key}) : super(key: key);

  @override
  State<grainsGalleryScreen> createState() => _grainsGalleryScreenState();
}

class _grainsGalleryScreenState extends State<grainsGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: 'Grains')
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
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ProductModel(
                products: snapshot.data!.docs[index],
              ),
            );
          },
          // staggeredTileBuilder: (context) => StaggeredTile.fit(1)
        );
      },
    );
  }
}
