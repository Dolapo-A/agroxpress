import 'package:agroxpresss/const.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 80,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    // horizontal: 20,
                    // vertical: 0,
                    ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/icons/search.png',
                    width: 15,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            padding: EdgeInsets.all(9),
            height: 80,
            decoration: BoxDecoration(
                color: generalColor, borderRadius: BorderRadius.circular(15)),
            // child: Image.asset(
            //   'assets/icons/filter.png',
            //   width: 25,
            // ),
            child: Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
