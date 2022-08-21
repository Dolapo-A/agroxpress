import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/categories/grains_category_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();
  List<ItemData> _item = [
    ItemData(categoryName: 'Grains'),
    ItemData(categoryName: 'Fruits\n and\n vegetables\n'),
    ItemData(categoryName: 'Tuber\n crops'),
    ItemData(categoryName: 'Protein'),
  ];

  // const CategoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.2,
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _item.length,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(index);
                        // for (var element in _item) {
                        //   element.isSelected = false;
                        // }
                        // setState(() {
                        //   _item[index].isSelected = true;
                        // });
                      },
                      child: Container(
                        color: _item[index].isSelected == true
                            ? Colors.grey.shade200
                            : Colors.transparent,
                        height: 100,
                        child: Center(
                          child: Text(_item[index].categoryName,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ));
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.80,
              color: Colors.grey.shade200,
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  for (var element in _item) {
                    element.isSelected = false;
                  }
                  setState(() {
                    _item[value].isSelected = true;
                  });
                },
                scrollDirection: Axis.vertical,
                children: [
                  GrainsCategoryScreen(),
                  Center(
                    child: Text('Fruits and Vegetables'),
                  ),
                  Center(
                    child: Text('Tuber crops'),
                  ),
                  Center(
                    child: Text('Protein'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ItemData {
  String categoryName;
  bool isSelected;

  ItemData({required this.categoryName, this.isSelected = false});
}
