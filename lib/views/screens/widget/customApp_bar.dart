import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Hello ,What are you\nLooking for? ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '👀', style: TextStyle(fontSize: 24)),
            ]),
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(
                            0.3,
                          ),
                          spreadRadius: 0.3,
                          blurRadius: 0.3,
                          offset: Offset(0, 1))
                    ]),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
