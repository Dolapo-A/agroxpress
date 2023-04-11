// import 'dart:html';

import 'dart:io';

import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/controllers/snack_bar_controller.dart';
import 'package:agroxpresss/utlilities/categories_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  int? discount = 0;

  String? categoryValue = null;
  bool _isLoading = false;

  late double price;
  late int quantity;
  late String productName;
  late String productDescription;
  late String productId;
  List<XFile>? imageList = [];
  List<String> imageUrlList = [];

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        // maxHeight: 300,
        // maxWidth: 100,
        imageQuality: 100,
      );
      setState(() {
        imageList = pickedImages!;
      });
    } catch (e) {}
  }

  Widget displayImages() {
    if (imageList!.isNotEmpty) {
      return InkWell(
        onTap: () {
          setState(() {
            imageList = null;
          });
        },
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageList!.length,
            itemBuilder: (context, index) {
              return Image.file(File(imageList![index].path));
            }),
      );
    } else {
      return Center(
        //     child: Text(
        //   'Pick an image(s)',
        //   style: TextStyle(fontSize: 18),
        // ),
        child: Icon(
          Icons.photo_camera_back_sharp,
          size: 40,
          color: Colors.grey,
        ),
      );
    }
  }

  Future<void> uploadImages() async {
    if (categoryValue != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imageList!.isNotEmpty) {
          try {
            for (var image in imageList!) {
              Reference ref =
                  _firebaseStorage.ref('Products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          return snackBar('Please pick an image', context);
        }
      } else {
        return snackBar('Please fields must not be empty', context);
      }
    } else {
      return snackBar('Please select a category', context);
    }
  }

  void uploadData() async {
    if (imageUrlList.isNotEmpty) {
      CollectionReference productRef = _firestore.collection('products');
      productId = Uuid().v4();

      await productRef.doc(productId).set({
        'productId': productId,
        'category': categoryValue,
        'price': price,
        'inStock': quantity,
        'productName': productName,
        'productDescription': productDescription,
        'sellerUid': FirebaseAuth.instance.currentUser!.uid,
        // 'VendorName': FirebaseAuth.instance.currentUser!.uid,
        'productImage': imageUrlList,
        'discount': discount,
      }).whenComplete(() {
        setState(() {
          imageList = [];
          categoryValue = null;
          imageUrlList = [];
        });
        _formKey.currentState!.reset();
      });

      return snackBar('Your product has successfully been uploaded', context);
    }
  }

  void uploadProduct() async {
    setState(() {
      _isLoading = true;
    });
    await uploadImages().whenComplete(() => uploadData());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickProductImages();
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: imageList != null
                                  ? displayImages()
                                  : Text(
                                      'Pick an image(s)',
                                      style: TextStyle(fontSize: 18),
                                    )),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 22),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              borderRadius: BorderRadius.circular(10),
                              hint: Text('Select Category'),
                              // value: category,
                              value: categoryValue,
                              focusColor: generalColor,
                              // dropdownColor: Colors.red,
                              items:
                                  category.map<DropdownMenuItem<String>>((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  categoryValue = value!;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: cross,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Price cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Price/Kg',
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            hintText: 'Price',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(5.0),
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
                          onSaved: (value) {
                            price = double.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Quantity cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            hintText: 'Quantity',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(5.0),
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
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return null;
                            } else if (value.isValidDiscount() != true) {
                              return 'Invalid discount';
                            }
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          // maxLengthEnforcement: ,
                          // enableIMEPersonalizedLearning: true,
                          decoration: InputDecoration(
                            labelText: 'Discount %',
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            hintText: 'Discount % ',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(5.0),
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
                          onSaved: (value) {
                            discount = int.parse(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Product name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Product Name',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(5.0),
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
                      onSaved: (value) {
                        productName = value!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Decscription must not be empty';
                        } else {
                          return null;
                        }
                      },
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 500,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Enter Product Description',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(5.0),
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
                      onSaved: (value) {
                        productDescription = value!;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: FloatingActionButton(
              backgroundColor: generalColor,
              onPressed: () {
                pickProductImages();
              },
              child: Icon(
                Icons.photo_library,
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: generalColor,
            onPressed: () {
              uploadProduct();
            },
            child: _isLoading
                ? SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    width: 20,
                    height: 20,
                  )
                : Icon(Icons.upload),
          ),
        ],
      ),
    );
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
