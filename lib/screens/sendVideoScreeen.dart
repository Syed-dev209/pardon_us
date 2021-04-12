import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pardon_us/models/messagesMethods.dart';
import 'package:video_player/video_player.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SendVideo extends StatefulWidget {
  File _video;
  String senderName, classCode;
  bool isPlaying = false;
  bool uploaded = false;
  SendVideo(this._video, this.senderName, this.classCode);
  @override
  _SendVideoState createState() => _SendVideoState();
}

class _SendVideoState extends State<SendVideo> {
  VideoPlayerController _videoPlayerController;
  MessengerMethods sendVideo;
  playVideo() {
    _videoPlayerController = VideoPlayerController.file(widget._video)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void initState() {
    playVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget._video.path);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('PARDON US'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: widget.uploaded,
          child: SafeArea(
              child: Column(
            children: [
              _videoPlayerController.value.initialized
                  ? Container(
                      height: 500.0,
                      width: 500.0,
                      child: VideoPlayer(_videoPlayerController))
                  : Container(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _videoPlayerController.value.isPlaying
                        ? _videoPlayerController.pause()
                        : _videoPlayerController.play();
                  });
                },
                icon: _videoPlayerController.value.isPlaying
                    ? Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 40.0,
                      )
                    : Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 40.0,
                      ),
              )
            ],
          )),
        ),
        floatingActionButton: GestureDetector(
          child: Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
          onTap: () async {
            sendVideo = MessengerMethods();
            try {
              setState(() {
                widget.uploaded = true;
              });
              bool check = await sendVideo.sendVideo(
                  widget._video, widget.senderName, widget.classCode);
              if (check) {
                setState(() {
                  widget.uploaded = false;
                });
                Navigator.pop(context);
              }
            } catch (e) {
              setState(() {
                widget.uploaded = false;
              });
              print(e);
            }
          },
        ));
  }
}
