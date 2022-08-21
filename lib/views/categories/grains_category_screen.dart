import 'package:agroxpresss/views/minor_screens/sub_category_screen.dart';
import 'package:flutter/material.dart';

import '../../utlilities/categories_list.dart';

class GrainsCategoryScreen extends StatelessWidget {
  // const GrainsCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
          child: Text(
            'Grains',
            style: TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 30,
              children: List.generate(grains.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SubCategoryScreen(
                          subCategoryName: grains[index],
                          mainCategory: 'Grains',
                        );
                      }));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.asset(
                                'assets/images/Grains/grains$index.jpg'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(grains[index])
                      ],
                    ),
                  ),
                );
              }),
            )),
      ],
    );
  }
}
