// import 'dart:html';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/gallery/fruits_vegetables_gallery_screen.dart';
import 'package:agroxpresss/views/gallery/grains_gallery_screen.dart';
import 'package:agroxpresss/views/gallery/protein_screen_gallery.dart';
import 'package:agroxpresss/views/gallery/tuber_crops_gallery_screen.dart';
import 'package:agroxpresss/views/inner_screens/search_screen.dart';
// import 'package:agroxpresss/views/screens/widget/category_list.dart';
// import 'package:agroxpresss/views/screens/widget/customApp_bar.dart';
// import 'package:agroxpresss/views/screens/widget/tagList.dart';
import 'package:flutter/material.dart';

// import 'widget/search_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // backgroundColor: generalColor.withOpacity(0.35),
        // body: Column(
        //   children: [CustomAppBar(), SearchInput(), TagList(), CategoryList()],
        // ),

        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,

          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext builder) {
                  return SearchScreen();
                }));
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: generalColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'What are you looking for?',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: generalColor,
            tabs: [
              RepeatedTab(title: 'Grains'),
              RepeatedTab(title: 'Fruits and Vegetables'),
              RepeatedTab(title: 'Tuber crops'),
              RepeatedTab(title: 'Protein'),
            ],
          ),
        ),
        body: TabBarView(children: [
          grainsGalleryScreen(),
          fruitsandVegetablesScreen(),
          tuberCropsScreen(),
          proteinsScreen()
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String title;
  const RepeatedTab({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40,
      child: Text(
        title,
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }
}
