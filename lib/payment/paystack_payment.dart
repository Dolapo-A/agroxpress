// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';

// class MakePayment {
//   MakePayment(
//       {required this.context,
//       required this.fullname,
//       required this.phone,
//       required this.amount,
//       required this.email});

//   BuildContext context;
//   double amount;
//   String fullname;
//   String email;
//   int phone;

//   PaystackPlugin paystack = PaystackPlugin();

//   String _getReference() {
//     String platform;
//     if (Platform.isIOS) {
//       platform = 'iOS';
//     } else {
//       platform = 'Android';
//     }

//     return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
//   }

//   Future initializePlugin() async {
//     await paystack.initialize(
//         publicKey: 'pk_test_cc0ae0eccd4dc4efad1aa188cd55673342fa7df2');
//   }

//   PaymentCard _getCarUI() {
//     return PaymentCard(number: '', cvc: '', expiryMonth: 0, expiryYear: 0);
//   }

//   ChargeCardANdMakePayment() async {
//     initializePlugin().then((_) async {
//       Charge charge = Charge()
//         ..locale = 'en_GH'
//         ..amount = amount.toInt() * 100
//         ..email = email
//         ..currency = 'GHS'
//         ..reference = _getReference()
//         ..accessCode = 'hello'
//         ..card = _getCarUI();

//       CheckoutResponse response = await paystack.checkout(context,
//           charge: charge, method: CheckoutMethod.selectable);

//       print('response $response');

//       if (response.status == true) {
//         print('Transaction successful');
//       } else {
//         print('Transaction failed');
//       }
//     });
//   }
// }
