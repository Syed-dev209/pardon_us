import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pardon_us/models/messagesMethods.dart';

class SendImage extends StatefulWidget {
  File _image;
  String senderName,classCode;
  SendImage(this._image,this.senderName,this.classCode);
  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  MessengerMethods sendImg;
  MediaQueryData mediaQueryData= MediaQueryData();
  @override
  Widget build(BuildContext context) {
    print(widget._image.path);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('PARDON US'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top:5.0,left: 12.0,right: 12.0,bottom: 90.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black26,
              image: DecorationImage(
                image: FileImage(widget._image),
                  fit: BoxFit.contain
              )

            ),
          ),
        ),

      ),
      floatingActionButton: GestureDetector(
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
          child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
      ),
        onTap: ()async{
          sendImg= MessengerMethods();
          try {
            sendImg.sendImage(widget._image, widget.senderName, widget.classCode);
            Navigator.pop(context);
          }
          catch(e){
              print(e);
          }

        },
    )
    );

  }
}
