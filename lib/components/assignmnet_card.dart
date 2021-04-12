import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../models/userDeatils.dart';

class AssignmentCard extends StatefulWidget {
  String assignmentTitle, dueTime, dueDate;
  String participantStatus, fileUrl, docId;
  bool lock;
  AssignmentCard(this.participantStatus, this.assignmentTitle, this.dueDate,
      this.dueTime, this.fileUrl, this.docId, this.lock);
  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  MediaQueryData queryData;
  AssignmentModel assignmentModel;
  String marksObtained = '0';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getStudentMarks() async {
    final user = await _firestore
        .collection('assignments')
        .doc(Provider.of<UserDetails>(context, listen: false).currentClassCode)
        .collection('assignment')
        .doc(widget.docId)
        .collection('attemptedBy')
        .where('name',
            isEqualTo:
                Provider.of<UserDetails>(context, listen: false).username)
        .get();
    for (var data in user.docs) {
      if (data.id != null) {
        setState(() {
          marksObtained = data.data()['marksObtained'];
        });
      } else {
        break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.participantStatus == 'Student') {
      getStudentMarks();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return GestureDetector(
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: 120.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
              leading: Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/assignmentCard.jpg'),
                        fit: BoxFit.fill),
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              title: Text(
                widget.assignmentTitle,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 23.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                ),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    DateTime.parse(widget.dueDate)
                        .toLocal()
                        .toString()
                        .split(' ')[0],
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.dueTime,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: widget.participantStatus == 'Student'
                  ? Column(
                      children: [
                        Text(
                          'Marks\nObtained',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '$marksObtained',
                          style: TextStyle(color: Colors.green, fontSize: 16.0),
                        )
                      ],
                    )
                  : Text(' ')),
        ),
      ),
      onTap: () {
        AlertBoxes _alert = AlertBoxes();
        DateTime dueDate = DateTime.parse(widget.dueDate);
        int checkLock = dueDate.compareTo(DateTime.now());
        final time = TimeOfDay.now();
        print(checkLock);
        if (widget.participantStatus == 'Student') {
          if (checkLock != 0 && time.toString() != widget.dueTime) {
            print(widget.docId);
            assignmentModel = AssignmentModel();
            assignmentModel.setAssignmentDetails(
                title: widget.assignmentTitle,
                time: widget.dueTime,
                date: widget.dueDate,
                fileUrl: widget.fileUrl,
                docId: widget.docId);
            Navigator.push(
                context,
                FadeRoute(
                    page: StudentUploadAssignment(
                  assDetails: assignmentModel,
                )));
          } else {
            _alert.simpleAlertBox(
                context,
                Text('Assignment Locked'),
                Text(
                    'Either you have attempted the assignment or due time is over.'),
                () {
              Navigator.pop(context);
            });
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentAssignmentAttemptList(
                        assDocId: widget.docId,
                      )));
        }
      },
    );
  }
}
