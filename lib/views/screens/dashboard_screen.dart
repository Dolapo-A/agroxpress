import 'dart:ui';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/dashboard_screens/vendor_balance_screen.dart';
import 'package:agroxpresss/views/dashboard_screens/vendor_edit_profile_screen.dart';
import 'package:agroxpresss/views/dashboard_screens/vendor_manage_products_screen.dart';
import 'package:agroxpresss/views/dashboard_screens/vendor_order_screen.dart';
import 'package:agroxpresss/views/dashboard_screens/vendor_statistics_screen.dart';
import 'package:agroxpresss/views/dashboard_screens/vendor_store_screen.dart';
import 'package:agroxpresss/views/minor_screens/visit_store_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_login_screen.dart';
import 'package:agroxpresss/views/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List<Widget> pages = [
    VendorStoreScreen(
      vendorUid: auth.currentUser!.uid,
    ),
    VendorOrderScreen(),
    EditProfileScreen(),
    ManageProductScreen(),
    BalanceScreen(),
    StatisticsScreen()
  ];
  List<String> title = [
    'My Store',
    'Orders',
    'Edit Profile',
    'Manage Products',
    'Balance',
    'Statistics',
  ];

  List<IconData> icon = [
    Icons.store,
    Icons.shop_2_outlined,
    Icons.edit,
    Icons.settings,
    Icons.attach_money,
    Icons.show_chart
  ];

  // Function to Signout Vendors
  logOut(context) async {
    await auth.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(VendorLoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          actions: [
            IconButton(
                onPressed: () {
                  logOut(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                ))
          ],
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
            'Dashboard',
            style: TextStyle(color: Colors.black, fontSize: 24),
          )),
      body: GridView.count(
        padding: EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: List.generate(6, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => pages[index]));
            },
            child: Card(
              elevation: 2,
              color: Colors.white54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon[index],
                    size: 40,
                    color: generalColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title[index].toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
