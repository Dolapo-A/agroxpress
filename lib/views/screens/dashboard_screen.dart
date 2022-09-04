// import 'dart:js';

// import 'dart:html';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/screens/auth/vendor_login_screen.dart';
import 'package:agroxpresss/views/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
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
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Dashboard',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
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
      ),
      body: GridView.count(
        padding: EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: List.generate(6, (index) {
          return Card(
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
          );
        }),
      ),
    );
  }
}
