import 'package:agroxpresss/provider/cart_provider.dart';
import 'package:agroxpresss/provider/wishlist_provider.dart';
import 'package:agroxpresss/splash_screen.dart';
import 'package:agroxpresss/views/screens/auth/user_login_screen.dart';
import 'package:agroxpresss/views/screens/auth/user_signup_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_login_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_signup_screen.dart';
import 'package:agroxpresss/views/screens/cart_screen.dart';
import 'package:agroxpresss/views/screens/customer_home_screen.dart';
import 'package:agroxpresss/views/screens/profile_screen.dart';
import 'package:agroxpresss/views/screens/vendor_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
          // options: const FirebaseOptions(
          //   apiKey: "AIzaSyB3UUd1shQSmSvckm0rXarf6Ls1wXlvrFc",
          //   authDomain: "agroxpresss.firebaseapp.com",
          //   projectId: "agroxpresss",
          //   storageBucket: "agroxpresss.appspot.com",
          //   messagingSenderId: "594762294321",
          //   appId: "1:594762294321:web:91c5c27b67f015762de110",
          //   measurementId: "G-7XF3PBW34G",
          // ),
          )
      .then((value) {
    print("Complete");
  });
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) {
      return CartProvider();
    }),
    ChangeNotifierProvider(create: (_) {
      return WishListProvider();
    })
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white)
    //     );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        CustomerHomeScreen.routeName: (context) => CustomerHomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        LandingVendorScreen.routeName: (context) => LandingCustomerScreen(),
        VendorLoginScreen.routeName: (context) => VendorLoginScreen(),
        vendorHomescreen.routeName: (context) => vendorHomescreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        CartScreen.routeName: (context) => CartScreen()
      },
    );
  }
}
