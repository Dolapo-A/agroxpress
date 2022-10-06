import 'dart:ui';

import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            style: TextStyle(color: Colors.black, fontSize: 22),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatisticsModel(
              label: 'Sold Out',
              value: '20',
            ),
            StatisticsModel(
              label: 'Item Count',
              value: '20',
            ),
            StatisticsModel(
              label: 'Total Balance',
              value: '20',
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class StatisticsModel extends StatelessWidget {
  final String label;
  final dynamic value;
  const StatisticsModel({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

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
            child: Center(
                child: Text(
              value.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ],
    );
  }
}
