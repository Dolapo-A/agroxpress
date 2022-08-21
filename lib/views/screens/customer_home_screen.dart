import 'package:agroxpresss/views/screens/cart_screen.dart';
import 'package:agroxpresss/views/screens/category_screen.dart';
import 'package:agroxpresss/views/screens/home_screen.dart';
import 'package:agroxpresss/views/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  static const String routeName = 'customerHomeScreen';
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int pageIndex = 0;

  final List<Widget> page = [
    HomeScreen(),
    CategoryScreen(),
    Center(
      child: Text('StoreScreen'),
    ),
    CartScreen(),
    ProfileScreen(),
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
                  Icons.home_filled,
                  size: 25,
                ),
                label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_rounded,
                  size: 25,
                ),
                label: 'Category'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.store,
                  size: 25,
                ),
                label: 'Store'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 25,
                ),
                label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 25,
                ),
                label: 'Profile'),
          ]),
      body: page[pageIndex],
    );
  }
}
