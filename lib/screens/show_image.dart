
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  MediaQueryData mediaQueryData;
  String imagePath;
  ShowImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    mediaQueryData=MediaQuery.of(context);
    print(imagePath);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: mediaQueryData.size.height,
            width: mediaQueryData.size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.contain
              )
            ),
          ),
        ),
      ),

    );
  }
}
