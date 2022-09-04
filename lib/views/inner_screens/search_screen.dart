import 'package:agroxpresss/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey[700],
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: generalColor),
        title: CupertinoSearchTextField(
          autofocus: true,
        ),
      ),
    );
  }
}
