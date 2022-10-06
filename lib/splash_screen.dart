import 'dart:async';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/screens/auth/user_login_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_login_screen.dart';
import 'package:agroxpresss/views/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';

import 'views/screens/customer_home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    // auth.currentUser != null;
    // ? AssistantMethods.readCurrentOnlineUserInfo()
    // : null;

    Timer(const Duration(seconds: 3), () async {
      if (await auth.currentUser != null) {
        // User? currentUser = auth.currentUser;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => CustomerHomeScreen()));
      } else {
        //send user to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (c) => LoginScreen())

      //     );
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/agroxpress-logo.png",
                height: 200,
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
