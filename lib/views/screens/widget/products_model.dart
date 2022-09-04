import 'package:agroxpresss/const.dart';
import 'package:agroxpresss/views/detail/product_detail_screen.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class ProductModel extends StatelessWidget {
  final dynamic products;
  const ProductModel({required this.products, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(
            productList: products,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Stack(
          children: [
            Container(
              // width: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(59, 21, 21, 21),
                        spreadRadius: 1,
                        blurRadius: 60,
                        offset: Offset(0, 10))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    child: Container(
                      constraints: BoxConstraints(
                        // minHeight: 100,
                        maxHeight: 130,
                      ),
                      // child: Image.network(
                      //   products['productImage'][0],
                      //   fit: BoxFit.fitWidth,
                      //   loadingBuilder: ,
                      // ),
                      // child: ca,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      products['productName'],
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                              color: grainsColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            products['category'],
                            // textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('C ' + products['price'].toString()),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_outline,
                              // size: 20,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Badge(
                toAnimate: true,
                animationType: BadgeAnimationType.fade,
                shape: BadgeShape.square,
                badgeColor: generalColor,
                borderRadius: BorderRadius.circular(10),
                badgeContent:
                    Text('New Arrival', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
