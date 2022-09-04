import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red.shade800,
            ),
          )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 65),
            child: ListView.builder(
                itemCount: cartProvider.count,
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              cartProvider.getItems[index].imagesUrl[0]
                                  .toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            children: [Text('data')],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
      ),

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         'Your cart is empty',
      //         style: TextStyle(fontSize: 24),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Container(
      //         width: 120,
      //         height: 120,
      //         decoration: BoxDecoration(
      //             image: DecorationImage(
      //                 image: AssetImage('assets/icons/empty_box2.png'))),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Material(
      //         color: generalColor,
      //         borderRadius: BorderRadius.circular(10),
      //         child: MaterialButton(
      //           onPressed: () {
      //             Navigator.of(context);
      //           },
      //           child: Text(
      //             'continue shopping',
      //             style: TextStyle(fontSize: 16, color: Colors.white),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Total: \GHC',
                  style: TextStyle(fontSize: 18, letterSpacing: 1),
                ),
                Text(
                  '0.00',
                  style: TextStyle(fontSize: 18, letterSpacing: 1),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: generalColor, borderRadius: BorderRadius.circular(10)),
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  'CHECK OUT',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
