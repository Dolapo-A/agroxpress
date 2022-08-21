import 'package:agroxpresss/controllers/auth_controller.dart';
import 'package:agroxpresss/controllers/snack_bar_controller.dart';
import 'package:flutter/material.dart';

import '../../../const.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // const ForgotPasswordScreen({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isLoading = false;

  forgotPassword() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthController().forgotPassword(_emailController.text);

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      snackBar("A password reset link has been sent to your email", context);
    } else {
      return snackBar(res, context);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => BottomNavBar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formkey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Forgot Password",
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black, fontSize: 18),
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
                borderSide: BorderSide(color: textFieldFocusColor, width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
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
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              if (_formkey.currentState!.validate()) {
                forgotPassword();
              }
              // print("you are logged in");
            },
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
                        "Reset Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}
