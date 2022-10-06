import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FullImageScreen extends StatefulWidget {
  final List<dynamic> imageList;

  const FullImageScreen({Key? key, required this.imageList}) : super(key: key);
  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  final PageController _pageController = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // navigationBar: CupertinoNavigationBar(
      //   previousPageTitle: 'Details',
      // ),
      // extendBodyBehindAppBar: true,

      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(
          'Product Gallery',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey[700],
            )),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 500),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                controller: _pageController,
                children: List.generate(widget.imageList.length, (index) {
                  return Center(
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.imageList[index].toString(),
                        placeholder: (context, url) {
                          return LinearProgressIndicator(
                            // minHeight: 2,
                            backgroundColor: Color.fromARGB(77, 67, 115, 102),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(208, 67, 115, 102)),
                          );
                          // return Icon(Icons.home);
                        },
                        errorWidget: (context, url, error) {
                          return Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.grey[400],
                            size: 40,
                          );
                        }),
                  );
                }),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.imageList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _pageController.jumpToPage(index);
                          },
                          child: Image.network(widget.imageList[index],
                              fit: BoxFit.fitWidth),
                        );
                      }),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    ('${index + 1}') + (' / ') + ('${widget.imageList.length}'),
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
