import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/screens/show_image.dart';
import 'package:pardon_us/screens/show_video.dart';
import 'package:pardon_us/models/managing_directory.dart';

class MessageBubble extends StatelessWidget {
  final String sender, text;
  bool isMe, isText;
  String type;
  Directory dir= Directory();

  MessageBubble({this.sender, this.text, this.isMe, this.type = 'text'});

  @override
  Widget build(BuildContext context) {
    print('$isMe');
    print('$sender');

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 2.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))
                : BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
            color: isMe ? Colors.blue : Colors.white,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: type == 'text'
                    ? Text(
                        '$text',
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black54,
                            fontSize: 15.0),
                      )
                    : type == 'image'
                        ? Stack(
                          children: [
                            GestureDetector(
                                child: Container(
                                  height: 200.0,
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      image: DecorationImage(
                                          image: NetworkImage(text),
                                          fit: BoxFit.cover)),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      ScaleRoute(
                                          page: ShowImage(
                                        imagePath: text,
                                      )));
                                },
                              ),
                           isMe?Padding(padding:EdgeInsets.symmetric(horizontal: 1.0) ): Padding(
                             padding: EdgeInsets.only(top: 210.0),
                             child: GestureDetector(
                               child: Container(
                                 height: 30.0,
                                 width: 30.0,
                                 decoration: BoxDecoration(
                                     color: Colors.green,
                                     borderRadius: BorderRadius.all(Radius.circular(15.0))
                                 ),
                                 child: Icon(Icons.download_rounded,size: 20,color: Colors.white,),
                               ),
                               onTap: () async {
                                 try {
                                   bool check = await dir.download(text);
                                 }
                                 catch(e){
                                   print(e);
                                 }

                               },
                             ),
                           )
                          ],
                        )
                        : GestureDetector(
                            child: Stack(
                              children: [
                                Container(
                                  height: 200.0,
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    size: 40.0,
                                    color: Colors.white,
                                  ),
                                ),
                               !isMe? Padding(
                                  padding: EdgeInsets.only(top: 210.0),
                                  child: GestureDetector(
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(Radius.circular(15.0))
                                      ),
                                      child: Icon(Icons.download_rounded,size: 20,color:Colors.white,),
                                    ),
                                    onTap: () async {
                                      try {
                                        bool check = await dir.download(text);
                                      }
                                      catch(e){
                                        print(e);
                                      }
                                    },
                                  ),
                                ):Container()
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  ScaleRoute(
                                      page: ShowVideo(
                                    videoPath: text,
                                  )));
                            },
                          )),
          ),
        ],
      ),
    );
  }
}
