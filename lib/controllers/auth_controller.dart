import 'dart:typed_data';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/screens/auth/user_login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/phone_number.dart';

class AuthController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //function to add image to Firebase storage
  _uploadImageToStorage(Uint8List? image) async {
    Reference ref =
        firebaseStorage.ref().child('ProfilePic').child(auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  // Function to pick image from gallery or camera
  pickImage(ImageSource Source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: Source);

    if (_file != null) {
      return _file.readAsBytes();
    } else {
      print("No image selected");
    }
  }

// Function to SignUp Users(Send User data to firebase)
  Future<String> SignUpUsers(String fullname, String email, String username,
      String phone, String password, Uint8List? image) async {
    String res = "Some error occured";
    try {
      if (fullname.isNotEmpty &&
          email.isNotEmpty &&
          username.isNotEmpty &&
          phone.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String downloadUrl = await _uploadImageToStorage(image);

        await firestore.collection('users').doc(cred.user!.uid).set({
          'fullName': fullname,
          'email': email,
          'username': username,
          'phone': phone,
          'image': downloadUrl,
        });
        // await auth.verifyPhoneNumber(
        //   phoneNumber: phone,
        //   verificationCompleted: (PhoneAuthCredential credential) async {
        //     // ANDROID ONLY!

        //     // Sign the user in (or link) with the auto-generated credential
        //     await auth.signInWithCredential(credential);
        //   },
        //   verificationFailed: (FirebaseAuthException e) {
        //     if (e.code == 'invalid-phone-number') {
        //       print('The provided phone number is not valid.');
        //     }

        //     // Handle other errors
        //   },
        //   codeSent: (String verificationId, int? resendToken) async {
        //     // Update the UI - wait for the user to enter the SMS code
        //     String smsCode = 'xxxx';

        //     // Create a PhoneAuthCredential with the code
        //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //         verificationId: verificationId, smsCode: smsCode);

        //     // Sign the user in (or link) with the credential
        //     await auth.signInWithCredential(credential);
        //   },
        //   timeout: const Duration(seconds: 60),
        //   codeAutoRetrievalTimeout: (String verificationId) {
        //     // Auto-resolution timed out...
        //   },
        // );
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

  //function to verify Users

  //function to login users
  loginUsers(String email, String password) async {
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

  // Function to reset password
  forgotPassword(String email) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty) {
        await auth.sendPasswordResetEmail(email: email);
        res = 'success';
        print("a password reset link has been sent to your email");
      } else {
        res = "Email field must not be empty";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
