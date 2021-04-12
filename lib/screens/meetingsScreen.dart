import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/CallPage2.dart';
import 'package:pardon_us/screens/callPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../utils/settings.dart';
import '../utils/settings.dart';
import 'dart:io' show Platform;

class MeetingScreen extends StatefulWidget {
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final _channelController = TextEditingController();
  final _passwordController = TextEditingController();
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
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 13.0),
        child: Column(
          children: [
            // TextFormField(
            //   controller: _channelController,
            //   decoration: InputDecoration(
            //       labelText: 'Meeting Code',
            //       border: OutlineInputBorder(),
            //       hintText: 'Enter meeting code here...',
            //       contentPadding:
            //           EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0)),
            // ),
            // SizedBox(
            //   height: 4.0,
            // ),
            // TextFormField(
            //   controller: _passwordController,
            //   decoration: InputDecoration(
            //       labelText: 'Meeting Password',
            //       border: OutlineInputBorder(),
            //       hintText: 'Enter meeting password here...',
            //       contentPadding:
            //           EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0)),
            // ),
            Text(
              'By Pressing this Button you can create a new meeting.',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[100]),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Provider.of<UserDetails>(context, listen: false)
                          .UserParticipantStatus ==
                      "Teacher"
                  ? Text('Start Meeting')
                  : Text('Join Meeting'),
              color: Colors.indigo,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              onPressed: () async {
                print('Start meeting pressed pressed');
                await _joinMeeting();
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 30.0,
              child: Divider(
                color: Colors.black26,
              ),
              width: 300.0,
            ),
            SizedBox(
              height: 20.0,
            ),
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

  _joinMeeting() async {
    String serverUrl = _passwordController.text?.trim()?.isEmpty ?? ""
        ? null
        : _passwordController.text;

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlag.callIntegrationEnabled = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlag.pipEnabled = false;
      }

      //uncomment to modify video resolution
      //featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room =
            Provider.of<UserDetails>(context, listen: false).currentClassCode
        ..serverURL = serverUrl
        ..subject = 'Video Conferencing'
        ..userDisplayName =
            Provider.of<UserDetails>(context, listen: false).Useremail
        ..userEmail = Provider.of<UserDetails>(context, listen: false).username
        ..audioOnly = true
        ..audioMuted = true
        ..videoMuted = true
        ..featureFlag = featureFlag;

      debugPrint("JitsiMeetingOptions: $options");
      JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onConferenceWillJoin: _onConferenceWillJoin,
        onError: _onError,
      ));
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }, onPictureInPictureWillEnter: ({message}) {
          debugPrint("${options.room} entered PIP mode with message: $message");
        }, onPictureInPictureTerminated: ({message}) {
          debugPrint("${options.room} exited PIP mode with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    print("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    print("_onConferenceTerminated broadcasted with message: $message");
  }

  void _onPictureInPictureWillEnter({message}) {
    debugPrint(
        "_onPictureInPictureWillEnter broadcasted with message: $message");
  }

  void _onPictureInPictureTerminated({message}) {
    debugPrint(
        "_onPictureInPictureTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
  // Future<void> onJoin() async {
  //   Token=_passwordController.text;
  //   if (_channelController.text.isNotEmpty) {
  //     // Wait for the permission for camera and microphone
  //     await _handleCameraAndMic(Permission.camera);
  //     await _handleCameraAndMic(Permission.microphone);
  //     //if(await Permission.camera.request().isGranted)
  //     // Enter the page for live streaming and join channel using the channel name and role specified in the login page
  //     if (Provider.of<UserDetails>(context, listen: false)
  //             .UserParticipantStatus ==
  //         "Teacher") {
  //       _role = ClientRole.Broadcaster;
  //     } else {
  //       _role = ClientRole.Audience;
  //     }
  //     await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CallPage(
  //           channelName: _channelController.text,
  //           role: ClientRole.Broadcaster,
  //         ),
  //       ),
  //     );
  //     // await Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (context) => CallPageSecond(
  //     //       appId: 'f235a1310fcc4347af2e567d3a742a3c',
  //     //       channel: _channelController.text,
  //     //       video: true,
  //     //       audio: true,
  //     //       screen: true,
  //     //       profile: '480p',
  //     //       width: '1000',
  //     //       height: '1000',
  //     //       framerate: ' ',
  //     //       codec: 'h264',
  //     //       mode: 'live',
  //     //     ),
  //     //   ),
  //     // );
  //   }
  // }
  //
  // // Ask for the permission for camera and microphone
  // Future<void> _handleCameraAndMic(Permission permission) async {
  //   final status = await permission.request();
  //   print(status);
  // }
}
