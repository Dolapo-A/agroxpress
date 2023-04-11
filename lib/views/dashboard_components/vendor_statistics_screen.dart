import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/currency_sign_controller.dart';
import 'package:agroxpresss/views/dashboard_components/vendor_order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('vendorUid',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          // String category;
          // snapshot.data!.docs;

          String category = '';
          for (var item in snapshot.data!.docs) {
            category = item['orderCategory'];
          }

          num orderQty = 0;
          for (var item in snapshot.data!.docs) {
            orderQty = item['orderQuantity'];
          }

          num itemCount = 0;
          for (var item in snapshot.data!.docs) {
            itemCount += item['orderQuantity'];
          }

          double totalprice = 0.0;
          for (var item in snapshot.data!.docs) {
            totalprice += item['orderPrice'];
            print(totalprice);
          }
          List<SalesData> data = [
            SalesData(category, orderQty),
            SalesData('Feb', 28),
            SalesData('Mar', 34),
            SalesData('Apr', 32),
            SalesData('May', 40)
          ];

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
                  'Statistics',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // SfSparkBarChart(
                  //   axisCrossesAt: 40,
                  // ),
                  // SfCartesianChart(
                  //   // Initialize category axis
                  //   primaryXAxis: CategoryAxis(),
                  //   series: <LineSeries<SalesData, String>>[
                  //     LineSeries<SalesData, String>(
                  //         // Bind data source
                  //         dataSource: data,
                  //         xValueMapper: (SalesData sales, _) =>
                  //             sales.category,
                  //         yValueMapper: (SalesData sales, _) => sales.Qty,
                  //         dataLabelSettings:
                  //             DataLabelSettings(isVisible: true)),
                  //   ],
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return VendorOrderScreen();
                      }));
                    },
                    child: StatisticsModel(
                      label: 'Orders recieved',
                      value: snapshot.data!.docs.length,
                      decimal: 0,
                    ),
                  ),

                  StatisticsModel(
                    label: 'sold(KG)',
                    value: itemCount,
                    decimal: 0,
                  ),
                  StatisticsModel(
                    label: 'Revenue ' + getCurrency(),
                    value: totalprice,
                    decimal: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        });
  }
}

class SalesData {
  SalesData(this.category, this.Qty);
  String category;
  num Qty;
}

class CategoryData {
  CategoryData(this.category, this.quantitySold);

  dynamic category;
  int quantitySold;
}

class StatisticsModel extends StatelessWidget {
  final String label;
  final int decimal;
  final dynamic value;
  const StatisticsModel(
      {Key? key,
      required this.label,
      required this.value,
      required this.decimal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          clipBehavior: Clip.antiAlias,
          shape: BeveledRectangleBorder(
              // side: BorderSide(color: Colors.blue), if you need
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
          )),
          child: Container(
            // transformAlignment: Transform.,
            height: 60,
            width: MediaQuery.of(context).size.width * 0.50,
            decoration: BoxDecoration(
              color: Colors.green[100],
            ),
            child: Center(
                child: Text(
              label.toUpperCase(),
              style: TextStyle(fontSize: 22),
            )),
          ),
        ),
        Material(
          clipBehavior: Clip.antiAlias,
          shape: BeveledRectangleBorder(
              // side: BorderSide(color: Colors.blue), if you need
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(20.0))),
          child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width * 0.50,
              decoration: BoxDecoration(
                color: Colors.green[200],
              ),
              child: AnimatedCounter(
                count: value,
                decimal: decimal,
              )),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int decimal;
  final dynamic count;
  const AnimatedCounter({Key? key, required this.count, required this.decimal})
      : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
            child: Text(
          _animation.value.toStringAsFixed(widget.decimal),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ));
      },
    );
  }
}
