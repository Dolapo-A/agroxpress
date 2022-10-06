import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/dashboard_screens/order%20status%20screens/delivered_screen.dart';
import 'package:agroxpresss/views/dashboard_screens/order%20status%20screens/preparing_screen.dart';
import 'package:agroxpresss/views/dashboard_screens/order%20status%20screens/shipping_screen.dart';
import 'package:flutter/material.dart';

class VendorOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
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
            bottom: TabBar(
              indicatorColor: generalColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 15),
              tabs: [
                Tab(
                  child: Text(
                    'Preparing',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Shipping',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Delivered',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Orders',
              style: TextStyle(color: Colors.black, fontSize: 24),
            )),
        body: TabBarView(children: [
          PreparingScreen(),
          ShippingScreen(),
          DeliveredScreen(),
        ]),
      ),
    );
  }
}
