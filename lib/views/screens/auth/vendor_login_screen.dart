import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/auth_controller.dart';
import 'package:agroxpresss/controllers/snack_bar_controller.dart';
import 'package:agroxpresss/views/screens/auth/forgot_password_screen.dart';
import 'package:agroxpresss/views/screens/auth/user_login_screen.dart';
import 'package:agroxpresss/views/screens/auth/user_signup_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_signup_screen.dart';
import 'package:agroxpresss/views/screens/customer_home_screen.dart';
import 'package:agroxpresss/views/screens/vendor_home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:the_validator/the_validator.dart';

import '../../../const.dart';
import '../../../const.dart';

class VendorLoginScreen extends StatefulWidget {
  static const String routeName = 'VendorloginScreen';
  const VendorLoginScreen({Key? key}) : super(key: key);

  @override
  State<VendorLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<VendorLoginScreen> {
  late String email;
  late String password;

  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool passwordVisible = true;

  bool _isLoading = false;

  // function to login vendors
  loginVendors(String email, String password) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);

        res = 'success';
        print('you are now logged in');
      } else {
        res = 'please fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  login() async {
    setState(() {
      _isLoading = true;
    });

    String res = await loginVendors(email, password);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      snackBar(res, context);
    } else {
      return Navigator.of(context).pushNamedAndRemoveUntil(
          vendorHomescreen.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 229, 241, 230),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 4,
                          blurRadius: 7)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, bottom: 10, top: 0),
                  child: Column(children: [
                    Image.asset(
                      "assets/images/agroxpress-logo.png",
                      width: 100,
                    ),
                    Text(
                      'Login as a vendor',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // email
                    TextFormField(
                      // controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: "Email",
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textFieldFocusColor, width: 2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),

                        //for the errors
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },

                      onChanged: (String value) {
                        email = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      // controller: _passwordController,
                      obscureText: passwordVisible,
                      // validator: FieldValidator.password(),
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: passwordVisible
                              ? Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                        ),
                        labelText: "Password",
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff437366), width: 2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),

                        //for the errors
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },

                      onChanged: (String value) {
                        password = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: const Alignment(1, 0),
                      child: RichText(
                          // key: _textsKey,
                          text: TextSpan(
                              text: 'Forgot Password?',
                              style:
                                  TextStyle(color: generalColor, fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          ForgotPasswordScreen(),
                                    )))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          login();
                        }
                        // print("you are logged in");
                      },
                      // onTap: loginUsers,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                  width: 20,
                                  height: 20,
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        // key: _textKey,
                        text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                              color: Color(0xff437366), fontSize: 14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      LandingVendorScreen(),
                                ))),
                    ])),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Or',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        // key: _textKey,
                        text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                            text: "Customer login? ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                              text: 'Click Here',
                              style: const TextStyle(
                                  color: Color(0xff437366), fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          LoginScreen(),
                                    ))),
                        ])),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
