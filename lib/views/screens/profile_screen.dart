import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/inner_screens/customer_order_screen.dart';
import 'package:agroxpresss/views/minor_screens/place_order_screen.dart';
import 'package:agroxpresss/views/screens/auth/forgot_password_profile_screen.dart';
import 'package:agroxpresss/views/screens/auth/forgot_password_screen.dart';
import 'package:agroxpresss/views/screens/auth/user_login_screen.dart';
import 'package:agroxpresss/views/screens/auth/vendor_login_screen.dart';
import 'package:agroxpresss/views/screens/cart_screen%20_product_details.dart';
import 'package:agroxpresss/views/screens/cart_screen.dart';
import 'package:agroxpresss/views/screens/wishlist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profileScreen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Function to logout of Profile
  logOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  //Function to delete account
  deleteAcc() async {}

  @override
  Widget build(BuildContext context) {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference customer =
        FirebaseFirestore.instance.collection('customers');

    return FutureBuilder(
      future: customer.doc(auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Something went wrong, unable to fetch data'));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          // return Text('Data does exist');
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  // automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  expandedHeight: 200,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      return FlexibleSpaceBar(
                        title: AnimatedOpacity(
                          opacity: constraints.biggest.height <= 100 ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Text('Account'),
                        ),
                        background: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Guest',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Phone',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Divider(
                                  color: Colors.grey.shade500,
                                  thickness: 0.8,
                                ),
                              ),
                              ListTile(
                                horizontalTitleGap: 5,
                                title: Text('Email'),
                                // subtitle: Text('dolapo@gmail.com'),
                                leading: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade200,
                                thickness: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 5,
                              title: Text(
                                'address: Nil',
                              ),
                              // subtitle: Text('No 4, rd 5, banana island'),
                              leading: Icon(
                                Icons.location_pin,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),
                            ListTile(
                              horizontalTitleGap: 5,
                              title: Text('Cart'),
                              leading: Icon(
                                Icons.shopping_cart,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),
                            ListTile(
                              horizontalTitleGap: 5,
                              title: Text('Orders'),
                              leading: Icon(
                                Icons.delivery_dining_rounded,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade200,
                              thickness: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: ListTile(
                                horizontalTitleGap: 5,
                                title: Text(
                                  'Log In',
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                                leading: Icon(
                                  Icons.login,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  // automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  expandedHeight: 180,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      return FlexibleSpaceBar(
                        title: AnimatedOpacity(
                          opacity: constraints.biggest.height <= 100 ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Text('Account'),
                        ),
                        background: Container(
                          child: SafeArea(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.grey[100],
                                              backgroundImage: NetworkImage(
                                                  '${data['image']}')),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data['fullName']}',
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${data['phone']}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Divider(
                                    color: Colors.grey.shade500,
                                    thickness: 0.8,
                                  ),
                                ),
                                InkWell(
                                  onTap: (() {}),
                                  child: ListTile(
                                    horizontalTitleGap: 5,
                                    title: Text('${data['email']}'),
                                    // subtitle: Text('dolapo@gmail.com'),
                                    leading: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade200,
                                  thickness: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 5,
                              title: Text(
                                '${data['address']}',
                              ),
                              // subtitle: Text('No 4, rd 5, banana island'),
                              leading: Icon(
                                Icons.location_pin,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CartScreenProductDetails()));
                              },
                              child: ListTile(
                                horizontalTitleGap: 5,
                                title: Text('Cart'),
                                leading: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CustomerOrderScreen();
                                }));
                              },
                              child: ListTile(
                                horizontalTitleGap: 5,
                                title: Text('Orders'),
                                leading: Icon(
                                  Icons.delivery_dining_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return WishlistScreen();
                                }));
                              },
                              child: ListTile(
                                horizontalTitleGap: 5,
                                title: Text('Wishlist'),
                                leading: Icon(
                                  Icons.favorite,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ForgotPasswordProfileScreen();
                                }));
                              },
                              child: ListTile(
                                horizontalTitleGap: 5,
                                title: Text('Change password'),
                                leading: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Divider(
                                color: Colors.grey.shade500,
                                thickness: 0.5,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return VendorLoginScreen();
                                }));
                              },
                              child: ListTile(
                                horizontalTitleGap: 5,
                                title: Text('Want to sell?'),
                                subtitle: Text(
                                  'You will need to create a vendor account if you do not have one',
                                  style: TextStyle(fontSize: 12),
                                ),
                                leading: Icon(
                                  CupertinoIcons.tag_circle,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade200,
                              thickness: 10,
                            ),
                            InkWell(
                              onTap: () {
                                MyAlertDilaog.showMyDialog(
                                    context: context,
                                    title: 'Log out',
                                    content: 'Do you want to log out?',
                                    tabNo: () {
                                      Navigator.pop(context);
                                    },
                                    tabYes: () {
                                      logOut();
                                    });
                              },
                              child: ListTile(
                                horizontalTitleGap: 5,
                                title: Text(
                                  'Log Out',
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                                leading: Icon(
                                  Icons.logout,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                            // ListTile(
                            //   horizontalTitleGap: 5,
                            //   title: Text(
                            //     'Delete Account',
                            //     style: TextStyle(color: Colors.red.shade700),
                            //   ),
                            //   leading: Icon(
                            //     Icons.delete,
                            //     color: Colors.red.shade700,
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: generalColor,
          ),
        );
      },
    );
  }
}
