import 'package:agroxpresss/views/screens/cart_screen.dart';
import 'package:agroxpresss/views/screens/category_screen.dart';
import 'package:agroxpresss/views/screens/dashboard_screen.dart';
import 'package:agroxpresss/views/screens/home_screen.dart';
import 'package:agroxpresss/views/screens/profile_screen.dart';
import 'package:agroxpresss/views/screens/upload_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class vendorHomescreen extends StatefulWidget {
  static const String routeName = 'vendorHomeScreen';
  const vendorHomescreen({Key? key}) : super(key: key);

  @override
  State<vendorHomescreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<vendorHomescreen> {
  int pageIndex = 0;

  final List<Widget> page = [
    DashBoardScreen(),
    UploadProductScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          currentIndex: pageIndex,
          backgroundColor: Colors.white,
          activeColor: Color(0xff437366),
          inactiveColor: Colors.black45,
          // backgroundColor: backgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                  size: 25,
                ),
                label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.sell,
                  size: 25,
                ),
                label: 'Upload'),
          ]),
      body: page[pageIndex],
    );
  }
}
