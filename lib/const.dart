// import 'package:agroxpresss/views/screens/cart_screen.dart';
// import 'package:agroxpresss/views/inner_screens/search_screen.dart';
// import 'package:agroxpresss/views/screens/home_screen.dart';
// import 'package:agroxpresss/views/screens/profile_screen.dart';
// import 'package:agroxpresss/views/screens/store_screen.dart';
// import 'package:agroxpresss/views/screens/upload_product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// PrimaryColor
var generalColor = Color(0xff437366);

var buttonColor = Color(0xff437366);
var textFieldFocusColor = Color(0xff437366);

// Category color
var grainsColor = Color.fromARGB(228, 199, 152, 1);

// TextFiel font size
double tffont = 16;

//FIREBASE
var auth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;
var analytics = FirebaseAnalytics.instance;

//LIST FOR PAGES
// List pages = [
//   HomeScreen(),
//   SearchScreen(),
//   StoreScreen(),
//   CartScreen(),
//   // UploadScreen(),
//   ProfileScreen(),
// ];

var firebaseStorage = FirebaseStorage.instance;
