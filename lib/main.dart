import 'package:agroxpresss/splash_screen.dart';
import 'package:agroxpresss/views/screens/auth/user_login_screen.dart';
import 'package:agroxpresss/views/screens/auth/user_signup_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_login_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_signup_screen.dart';
import 'package:agroxpresss/views/screens/bottom_navbar.dart';
import 'package:agroxpresss/views/screens/customer_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    print("Complete");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.rubikTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        CustomerHomeScreen.routeName: (context) => CustomerHomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        LandingVendorScreen.routeName: (context) => LandingCustomerScreen(),
        VendorLoginScreen.routeName: (context) => VendorLoginScreen(),
      },
    );
  }
}
