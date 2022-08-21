// import 'dart:async';

// import 'package:agroxpresss/const.dart';
// import 'package:agroxpresss/views/screens/auth/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:users_app/assistants/assistant_methods.dart';
// import 'package:users_app/authentication/login_screen.dart';
// import 'package:users_app/global/global.dart';
// import 'package:users_app/mainScreens/main_screen.dart';

// class MySplashScreen extends StatefulWidget {
//   const MySplashScreen({Key? key}) : super(key: key);

//   @override
//   _MySplashScreenState createState() => _MySplashScreenState();
// }

// class _MySplashScreenState extends State<MySplashScreen> {
//   startTimer() {
//     auth.currentUser != null
//         ? AssistantMethods.readCurrentOnlineUserInfo()
//         : null;

//     Timer(const Duration(seconds: 3), () async {
//       if (await auth.currentUser != null) {
//         currentFirebaseUser = auth.currentUser;
//         Navigator.push(
//             context, MaterialPageRoute(builder: (c) => MainScreen()));
//       } else {
//         //send user to login screen
//         Navigator.push(
//             context, MaterialPageRoute(builder: (c) => LoginScreen()));
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     startTimer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Material(
//       child: Container(
//         // color: Colors.black,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 isDarkMode
//                     ? "images/helpy_user_darkmode.png"
//                     : "images/helpy_user.png",
//                 height: 120,
//                 width: 180,
//               ),
//               // const SizedBox(
//               //   height: 10,
//               // ),
//               // const Text("Uber & InDriver Clone App",
//               //     style: TextStyle(
//               //         fontSize: 20,
//               //         color: Colors.white,
//               //         fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/screens/customer_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/screens/auth/user_login_screen.dart';

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
