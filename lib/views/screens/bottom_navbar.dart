// import 'package:agroxpresss/const.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// // ignore: must_be_immutable
// class BottomNavBar extends StatefulWidget {
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int pageIndex = 0;

//   // const BottomNavBar({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CupertinoTabBar(
//           onTap: (index) {
//             setState(() {
//               pageIndex = index;
//             });
//           },
//           currentIndex: pageIndex,
//           backgroundColor: Colors.white,
//           activeColor: Color(0xff437366),
//           inactiveColor: Colors.black45,
//           // backgroundColor: backgroundColor,
//           items: [
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.home_filled,
//                   size: 25,
//                 ),
//                 label: 'Home'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.search_rounded,
//                   size: 25,
//                 ),
//                 label: 'Search'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.store,
//                   size: 25,
//                 ),
//                 label: 'Store'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.shopping_cart,
//                   size: 25,
//                 ),
//                 label: 'Cart'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.person,
//                   size: 25,
//                 ),
//                 label: 'Profile'),
//           ]),
//       // body: pages[pageIndex],
//     );
//   }
// }
