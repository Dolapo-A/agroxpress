import 'package:agroxpresss/const.dart';
import 'package:flutter/material.dart';

class TagList extends StatelessWidget {
  final tagList = [
    'Grains',
    'Fruits and Vegetables',
    'Tuber crops',
    'Protein',
    'Yam'
  ];
  TagList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tagList
            .map((e) => Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: generalColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Text(
                    e,
                    style: TextStyle(color: Color.fromARGB(184, 255, 255, 255)),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
