import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:pardon_us/components/alertBox.dart';
import 'package:pardon_us/models/excelServices.dart';
import 'package:pardon_us/models/meetingController.dart';
import 'package:pardon_us/models/messagesMethods.dart';
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
  MeetingController _meetingController;
  bool enableButton = false;
  String fileName;
  ExcelSheet exc = ExcelSheet();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 13.0),
      child: Column(
        children: [
          Text(
            Provider.of<UserDetails>(context, listen: false)
                        .UserParticipantStatus ==
                    "Teacher"
                ? 'By Pressing this Button you can create a new meeting.'
                : 'By Pressing this button you can join the meeting.',
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
              _meetingController = MeetingController();
              print('Start meeting pressed pressed');

              ///for TEACHER
              if (Provider.of<UserDetails>(context, listen: false)
                      .UserParticipantStatus ==
                  "Teacher") {
                fileName = exc.createNewExcel(
                    Provider.of<UserDetails>(context, listen: false)
                        .currentClassCode);

                bool check = await _meetingController.createMeeting(context);
                if (check) {
                  setState(() {
                    enableButton = true;
                  });
                  await _joinMeeting();
                }
              }

              ///Student
              else {
                bool check = await _meetingController.onJoinMeeting(context);
                if (check) {
                  await _joinMeeting();
                } else {
                  AlertBoxes _alert = AlertBoxes();
                  _alert.simpleAlertBox(context, Text('No host found'),
                      Text('Your instructor has\'nt started meeting yet.'), () {
                    Navigator.pop(context);
                  });
                }
              }
            },
          ),
          Provider.of<UserDetails>(context, listen: false)
                      .UserParticipantStatus ==
                  "Teacher"
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                  ),
                  onPressed: enableButton
                      ? () async {
                          _meetingController = MeetingController();
                          if (Provider.of<UserDetails>(context, listen: false)
                                  .UserParticipantStatus ==
                              'Teacher') {
                            print('terminator triggered, I am Teacher');
                            bool check = await _meetingController.endMeeting(
                                context, fileName, exc);
                            print('prinitng check = $check');
                            if (check) {
                              print(
                                  'attendance uploaded and mission successful');
                            } else {
                              print('end meeting nahi chla ');
                            }
                          } else {
                            print('terminator triggered, I am Student');
                            await _meetingController.onLeavingMeeting(context);
                          }
                          setState(() {
                            enableButton = false;
                          });
                        }
                      : null,
                  child: Text('Generate Attendance Report'),
                )
              : Text(' '),
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
          Provider.of<UserDetails>(context, listen: false)
                      .UserParticipantStatus ==
                  "Teacher"
              ? Container(
                  //color: Colors.indigo,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: SingleChildScrollView(
                    child: StreamBuilder(
                      stream: _firestore
                          .collection('meetings')
                          .doc(Provider.of<UserDetails>(context, listen: false)
                              .currentClassCode)
                          .collection('meetingRecord')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final record = snapshot.data.docs;
                        List<Widget> tiles = [];
                        for (var data in record) {
                          if (data.data()['fileUrl'] != ' ') {
                            tiles.add(reportTile(data.data()['DateTime'],
                                data.data()['fileUrl']));
                          }
                        }
                        return Column(
                          children: tiles,
                        );
                      },
                    ),
                  ),
                )
              : Text(' ')
        ],
      ),
    );
  }

  Widget reportTile(String date, String fileUrl) {
    bool loader = false;
    return ListTile(
      onTap: () {
        setState(() {
          loader = true;
        });
        MessengerMethods _msg = MessengerMethods();
        _msg.sendLink(
            senderName:
                Provider.of<UserDetails>(context, listen: false).username,
            classCode: Provider.of<UserDetails>(context, listen: false)
                .currentClassCode,
            link: fileUrl,
            type: 'link');
        setState(() {
          loader = false;
        });

        AlertBoxes _alert = AlertBoxes();
        _alert.simpleAlertBox(context, Text('Congratulations'),
            Text('Attendance report has been sent to students via messenger'),
            () {
          Navigator.pop(context);
        });
      },
      trailing:
          loader ? CircularProgressIndicator() : Icon(Icons.share_outlined),
      leading: Image.asset('images/csv.png'),
      title: Text('Attendance Report'),
      subtitle: Text('Date:- $date'),
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
      JitsiMeet.addListener(
        JitsiMeetingListener(
          onConferenceJoined: _onConferenceJoined,
          onConferenceTerminated: _onConferenceTerminated,
          onConferenceWillJoin: _onConferenceWillJoin,
          onError: _onError,
        ),
      );
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated message: $message");
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
}
