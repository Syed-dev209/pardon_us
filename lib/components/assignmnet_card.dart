import 'package:flutter/material.dart';
import 'package:pardon_us/components/alertBox.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/screens/assignments_screens/studentAssignmentAttemptList.dart';
import 'package:pardon_us/screens/assignments_screens/student_assignment_upload.dart';
import 'package:pardon_us/screens/quiz_screens/mcqs_attempt_screen.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/screens/quiz_screens/student_uplod_quiz-screen.dart';
import 'package:pardon_us/screens/quiz_screens/mcqs_create_screen.dart';
import 'package:pardon_us/screens/quiz_screens/teacher_upload_quiz_screen.dart';
import 'package:pardon_us/screens/participants.dart';
import 'package:provider/provider.dart';
import 'package:pardon_us/models/assignmentModel.dart';


class AssignmentCard extends StatefulWidget {
  String assignmentTitle,dueTime,dueDate;
  String participantStatus,fileUrl,docId;
  bool lock;
  AssignmentCard(this.participantStatus,this.assignmentTitle,this.dueDate,this.dueTime,this.fileUrl,this.docId,this.lock);
  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  MediaQueryData queryData;
  AssignmentModel assignmentModel;
  @override
  Widget build(BuildContext context) {
    queryData=MediaQuery.of(context);
    return GestureDetector(
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
          height: 120.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),

          ),
          child: Padding(
            padding: EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius:40.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0,top: 10.0),
                  child: Column(
                    //direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 200.0,
                          child: Text(widget.assignmentTitle,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1
                            ,),
                        ),

                      ),
                      SizedBox(
                        height: 10.0,
                        width: 200.0,
                        child: Divider(color: Colors.black26,),
                      ),

                      Expanded(
                        child: Text(DateTime.parse(widget.dueDate).toLocal().toString().split(' ')[0],style: TextStyle(
                          color: Colors.green,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,

                        ),),
                      ),
                      Expanded(
                        child: Text(widget.dueTime,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,

                          ),),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: (){
        AlertBoxes _alert= AlertBoxes();
        DateTime dueDate= DateTime.parse(widget.dueDate);
        int checkLock= dueDate.compareTo(DateTime.now());
        print(widget.participantStatus);
        if(widget.participantStatus=='Student') {
          if (widget.lock) {
            print(widget.docId);
            assignmentModel = AssignmentModel();
            assignmentModel.setAssignmentDetails(title: widget.assignmentTitle,
                time: widget.dueTime,
                date: widget.dueDate,
                fileUrl: widget.fileUrl,
                docId: widget.docId);
            Navigator.push(context, FadeRoute(
                page: StudentUploadAssignment(assDetails: assignmentModel,)));
          }
          else {
            _alert.simpleAlertBox(context, Text('Assignment Locked'), Text(
                'Either you have attempted the assignment or due time is over.'), () {
              Navigator.pop(context);
            });
          }
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentAssignmentAttemptList(assDocId: widget.docId,)));
        }
      },
    );
  }
}
