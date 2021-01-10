import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  MediaQueryData mediaQueryData;
  String videoPath;
  ShowVideo({this.videoPath});
  VideoPlayerController _videoPlayerController;

  @override
  _ShowVideoState createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  playVideo(){
    widget._videoPlayerController = VideoPlayerController.network(widget.videoPath)..initialize().then((_){
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
    widget.mediaQueryData=MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body:SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              widget._videoPlayerController.value.initialized?Container(
                height: 700,
                width: widget.mediaQueryData.size.width,
                child: VideoPlayer(widget._videoPlayerController),
              ):Container(),
              Opacity(
                opacity: 0.5,
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      widget._videoPlayerController.value.isPlaying?widget._videoPlayerController.pause():widget._videoPlayerController.play();
                    });
                  },
                  icon:widget._videoPlayerController.value.isPlaying?Icon(Icons.pause,color: Colors.white,size: 70.0,):Icon(Icons.play_circle_outline,color: Colors.white,size: 70.0,),
                ),
              )
            ],
          ),
        ),
      )

    );
  }
}
