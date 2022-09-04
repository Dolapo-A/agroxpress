// import 'dart:io';
// import 'dart:js';

import 'package:flutter/material.dart';

snackBar(String title, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xff437366),
      content: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      )));
}
