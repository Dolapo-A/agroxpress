import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/snack_bar_controller.dart';
import 'package:agroxpresss/views/screens/widget/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitStoreScreen extends StatelessWidget {
  final vendorUid;

  const VisitStoreScreen({Key? key, this.vendorUid}) : super(key: key);

  // void launchWhatsApp({
  //   @required int phone,
  //   @required String message,
  // }) async {
  //   String url() {
  //     if (Platform.isAndroid) {
  //       return "whatsapp://wa.me/$phone:03452121308:/?text=${Uri.parse(message)}";
  //     } else {
  //       return "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}";
  //     }
  //   }

  //   if (await canLaunch(url())) {
  //     await launch(url());
  //   } else {
  //     throw 'Could not launch ${url()}';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sellerUid', isEqualTo: vendorUid)
        .snapshots();
    CollectionReference vendor =
        FirebaseFirestore.instance.collection('vendors');

    return FutureBuilder<DocumentSnapshot>(
      future: vendor.doc(vendorUid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Material(child: Center(child: Text("Something went wrong")));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Material(
              child: Center(child: Text("Document does not exist")));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // var phone = data['phone'];
          var phone = data['phone'];
          Uri whatsappUrl = Uri.parse('https://wa.me/$phone');
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              toolbarHeight: 60,
              centerTitle: true,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 500),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.grey,
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(4.0)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.grey[700],
                  )),
              title: Text(
                data['storeName'],
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
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
                      'This store has no item on display yet\n🙁',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 250,
                    // crossAxisSpacing: 25,
                    // mainAxisSpacing: 20
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  // crossAxisCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductModel(
                      products: snapshot.data!.docs[index],
                    );
                  },
                  // staggeredTileBuilder: (context) => StaggeredTile.fit(1)
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // whatsappUrl.contains(RegExp(source))

                // urlget() {
                //   _launchURL() async {
                //     if (await canLaunchUrl(whatsappUrl)) {
                //       await launchUrl(whatsappUrl);
                //     } else {
                //       throw 'Could not launch $whatsappUrl';
                //     }
                //   }

                //   WebView(
                //     initialUrl: 'ttps://wa.me/$phone',
                //     javascriptMode: JavascriptMode.unrestricted,
                //     navigationDelegate: (NavigationRequest request) {
                //       if (request.url
                //           .startsWith('https://my.redirect.url.com')) {
                //         print('blocking navigation to $request}');
                //         _launchURL();
                //         return NavigationDecision.prevent;
                //       }

                //       print('allowing navigation to $request');
                //       return NavigationDecision.navigate;
                //     },
                //   );
                // }

                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl);
                } else {
                  snackBar('Error', context);
                }
              },
              backgroundColor: generalColor,
              child: Icon(
                FontAwesomeIcons.whatsapp,
              ),
            ),
          );
        }

        return Material(
          child: Center(
            child: CircularProgressIndicator(
              color: generalColor,
            ),
          ),
        );
      },
    );
  }
}
