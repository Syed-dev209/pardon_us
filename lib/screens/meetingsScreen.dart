import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/callPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MeetingScreen extends StatefulWidget {
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole _role;
  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 12.0,vertical: 13.0),
        child: Column(
          children: [
            TextFormField(
              controller: _channelController,
              decoration:  InputDecoration(
                  labelText: 'Meeting Code',
                  border: OutlineInputBorder(),
                  hintText: 'Enter meeting code here...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
              ),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              child: Text('Start Meeting'),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)
              ),
              onPressed: ()async{
                print('Start meeting pressed pressed');
                await onJoin();
              },
            ),
            SizedBox(height: 20.0,),
            SizedBox(height: 30.0,child: Divider(color: Colors.black26,),width: 300.0,),
            SizedBox(height: 20.0,),
            ListTile(
              leading: Image.asset('images/csv.png'),
              title: Text('Attendance Report'),
              subtitle: Text('Date:- 20/12/2010 Time:- 40:00 min'),
            )

          ],
        ),
      ),
    );
  }
  Future<void> onJoin() async {
    if (_channelController.text.isNotEmpty) {
      // Wait for the permission for camera and microphone
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      //if(await Permission.camera.request().isGranted)
      // Enter the page for live streaming and join channel using the channel name and role specified in the login page
      if(Provider.of<UserDetails>(context,listen: false).UserParticipantStatus=="Teacher")
        {
          _role=ClientRole.Broadcaster;
        }
      else{
        _role=ClientRole.Audience;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  // Ask for the permission for camera and microphone
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

