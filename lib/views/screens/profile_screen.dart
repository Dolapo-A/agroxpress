import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/screens/auth/user_login_screen.dart';
import 'package:agroxpresss/views/screens/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
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
        FirebaseFirestore.instance.collection('users');

    return FutureBuilder(
      future: customer.doc(auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text('Data does exist');
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
                                                  fontWeight: FontWeight.bold),
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
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
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
                              title: Text('Address'),
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
                                        builder: (context) => CartScreen()));
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
                            ListTile(
                              horizontalTitleGap: 5,
                              title: Text('Wishlist'),
                              leading: Icon(
                                Icons.heart_broken,
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
                              title: Text('Forgot Password?'),
                              leading: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade200,
                              thickness: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                logOut();
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
                            ListTile(
                              horizontalTitleGap: 5,
                              title: Text(
                                'Delete Account',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              leading: Icon(
                                Icons.delete,
                                color: Colors.red.shade700,
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

        return Center(
          child: CircularProgressIndicator(
            color: generalColor,
          ),
        );
      },
    );
  }
}
