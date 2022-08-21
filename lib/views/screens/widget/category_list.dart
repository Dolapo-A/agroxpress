import 'package:flutter/material.dart';

import '../../../const.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'New Arrival',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View All',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: generalColor,
                    borderRadius: BorderRadius.circular(10)),
                // child: Image.asset(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
