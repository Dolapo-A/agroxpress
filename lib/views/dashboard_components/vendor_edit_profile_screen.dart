import 'dart:ui';

import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  // final dynamic data;
  // const EditProfileScreen({Key? key, required this.data}) : super(key: key);
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 60,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.grey[700],
              )),
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
            'Edit Profile',
            style: TextStyle(color: Colors.black, fontSize: 22),
          )),
      body: Column(
        children: [
          Column(
            children: [
              Text(
                'Store logo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 60,
                  ),
                  TextButton(onPressed: () {}, child: Text('Edit image'))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
