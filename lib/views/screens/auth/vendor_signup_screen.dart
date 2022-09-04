import 'dart:io';
import 'dart:typed_data';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/auth_controller.dart';
import 'package:agroxpresss/controllers/snack_bar_controller.dart';
import 'package:agroxpresss/views/screens/auth/user_signup_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:the_validator/the_validator.dart';

class LandingVendorScreen extends StatefulWidget {
  static const String routeName = 'LandingVendorScreen';

  @override
  State<LandingVendorScreen> createState() => _LandingCustomerScreenState();
}

class _LandingCustomerScreenState extends State<LandingVendorScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late String fullName;
  late String email;
  late String address;
  late PhoneNumber phone;
  late String password = '';

  final AuthController _authController = AuthController();
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String res = "Some error occured";

  // final TextEditingController _fullNameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordTextController =
      TextEditingController();
  bool passwordVisible = true;

  bool isLoading = false;

  Uint8List? _image;

  selectImageGallery() async {
    Uint8List img = await AuthController().pickImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
    Navigator.pop(context);
  }

  selectImageCamera() async {
    Uint8List im = await AuthController().pickImage(ImageSource.camera);

    setState(() {
      _image = im;
    });

    Navigator.pop(context);
  }

  _uploadImageToStorage(Uint8List? image) async {
    Reference ref = firebaseStorage.ref().child('ProfilePic').child(fullName);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Choose option",
                style: TextStyle(color: Colors.black),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      selectImageGallery();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: generalColor,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      selectImageCamera();
                    },
                    title: Text(
                      "Camera",
                    ),
                    leading: Icon(
                      Icons.camera_alt,
                      color: generalColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//function to sign up vendors
  Future<String> signUpVendors(
    String fullName,
    String email,
    String address,
    String phone,
    String password,
    Uint8List? _image,
  ) async {
    try {
      if (fullName.isNotEmpty &&
          email.isNotEmpty &&
          address.isNotEmpty &&
          phone.isNotEmpty &&
          password.isNotEmpty &&
          _image != null) {
        await _fireAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        String downloadUrl = await _uploadImageToStorage(_image);

        await _firestore
            .collection('vendors')
            .doc(_fireAuth.currentUser!.uid)
            .set({
          'vendorUid': _fireAuth.currentUser!.uid,
          'storeName': fullName,
          'email': email,
          'address': address,
          'phone': phone,
          'image': downloadUrl,
        });

        res = 'success';
        print("Account Created");
      } else {
        res = 'Please fields must not be empty';

        print("Please fields must not be empty");
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  signUp() async {
    setState(() {
      isLoading = true;
    });

    String res = await signUpVendors(
        fullName, email, address, phone.number, password, _image);

    setState(() {
      isLoading = false;
    });

    if (_image == null) {
      return snackBar('Please pick an image', context);
    } else if (res != 'success') {
      return snackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => VendorLoginScreen()));
    }
  }

  // const LandingVendorScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create vendor account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Color.fromARGB(238, 67, 115, 102),
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundColor: Color.fromARGB(238, 67, 115, 102),
                          backgroundImage:
                              AssetImage('assets/icons/avatar.jpg')),
                  Positioned(
                      right: 5,
                      bottom: 10,
                      child: GestureDetector(
                        onTap: () {
                          showChoiceDialog(context);
                        },
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          color: Color.fromARGB(245, 113, 113, 113),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      // controller: _fullNameController,
                      textCapitalization: TextCapitalization.words,

                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: "Store Name",
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
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
                        fullName = value;
                      },
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
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      onChanged: (String value) {
                        email = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // address
                    TextFormField(
                      // controller: _usernameController,
                      textCapitalization: TextCapitalization.sentences,

                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: "Address",
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
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
                        address = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Phone Number
                    IntlPhoneField(
                      disableLengthCheck: true,
                      showCountryFlag: true,
                      // controller: _phoneController,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
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
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'This field is required';
                      //   }
                      //   return null;
                      // },
                      initialCountryCode: 'GH',
                      onChanged: (value) {
                        print(value.completeNumber);
                        phone = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Password
                    TextFormField(
                      // controller: _passwordController,
                      obscureText: passwordVisible,
                      validator: FieldValidator.password(
                          minLength: 8,
                          shouldContainNumber: true,
                          shouldContainCapitalLetter: true,
                          shouldContainSmallLetter: true,
                          shouldContainSpecialChars: true,
                          errorMessage:
                              "Password must match the required format",
                          onNumberNotPresent: () {
                            return "Password must contain at least one Number";
                          },
                          onSpecialCharsNotPresent: () {
                            return "Password must contain special characters";
                          },
                          onCapitalLetterNotPresent: () {
                            return "Must contain CAPITAL letters";
                          }),
                      onChanged: (String value) {
                        password = value;
                      },
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     "\u2022 Password must be at least 8 characters",
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     "\u2022 Password must contain at least one Capital letter,",
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // Align(
                    //   alignment: Alignment(-0.9, 0),
                    //   child: Text(
                    //     "Number, and Special Character",
                    //     // textAlign: TextAlign.right,
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 7,
                    // ),
                    //confirmpassword
                    TextFormField(
                      controller: _confirmpasswordTextController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
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

                        //for the error message
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
                      validator: FieldValidator.equalTo(password,
                          message: "Password mismatch"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xff437366),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                  width: 20,
                                  height: 20,
                                )
                              : Text(
                                  "Sign Up",
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
                      height: 15,
                    ),
                    RichText(
                        // key: _textKey,
                        text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                          text: 'Login Here',
                          style: const TextStyle(
                              color: Color(0xff437366), fontSize: 14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      VendorLoginScreen(),
                                ))),
                    ])),
                    Text(
                      'Or',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    RichText(
                        // key: _textKey,
                        text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                        text: "Create a customer account ",
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
                                      LandingCustomerScreen(),
                                ))),
                    ])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
