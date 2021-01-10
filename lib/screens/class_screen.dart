import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/components/drawer_item.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/participants.dart';
import 'package:pardon_us/screens/start_screen.dart';
import 'package:provider/provider.dart';
import 'assignments_screens/assignment_screen.dart';
import 'message_screen.dart';
import 'quiz_screens/quiz_screen.dart';
import 'package:pardon_us/screens/meetingsScreen.dart';

class ClassScreen extends StatefulWidget {

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  String name;
  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirm Exit?',
            style: new TextStyle(color: Colors.black, fontSize: 20.0)),
        content: new Text(
            'Do you wish to exit this class?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              //Provider.of<UserDetails>(context,listen: false).setUserClassStatus(null, null);
              Navigator.push(context, ScaleRoute(page:Start()));
            },
            child:
            new Text('Yes', style: new TextStyle(fontSize: 18.0)),
          ),
          new FlatButton(
            onPressed: () => Navigator.pop(context), // this line dismisses the dialog
            child: new Text('No', style: new TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF303F9F),
            // leading: Icon(Icons.list),
            title: Text('PARDON US'),
            bottom: TabBar(
              tabs: [
                Tab(icon:Icon(Icons.question_answer),text: 'Messages' ),
                Tab(icon:Icon(Icons.error_outline),text: 'Quiz'),
                Tab(icon:Icon(Icons.assignment_late),text: 'Assignment'),
                Tab(icon: Icon(Icons.video_call),text:'Meetings',)
              ],

          ),
            actions: [
              IconButton(
                  icon: Icon(Icons.person_pin,color: Colors.white,)
                  ,iconSize: 32.0,
                onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(
                     builder: (context)=>Participants()
                   ));
                },
              )
            ],
          ),
            drawer:DrawerItem(),
          body: SafeArea(
            child: Consumer<UserDetails>(
              builder: (context,user,child){
                name=user.username;
                return TabBarView(
                  children: [
                    MessagesScreen(classCode: user.currentClassCode,username: user.username),
                    QuizScreen(participantStatus: user.UserParticipantStatus),
                    AssignmentScreen(participantStatus: user.UserParticipantStatus),
                    MeetingScreen()
                  ],
                );
              },
            )
          ),
        ),
      ),
      onWillPop: onWillPop,
    );
  }
}
