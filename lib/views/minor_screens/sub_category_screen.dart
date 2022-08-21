import 'package:agroxpresss/const.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatelessWidget {
  final String subCategoryName;
  final String mainCategory;

  const SubCategoryScreen(
      {Key? key, required this.subCategoryName, required this.mainCategory})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          subCategoryName,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text(mainCategory),
      ),
    );
  }
}
