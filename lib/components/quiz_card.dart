import 'package:flutter/material.dart';
import 'package:pardon_us/components/alertBox.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/screens/quiz_screens/mcqs_attempt_screen.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/screens/quiz_screens/student_uplod_quiz-screen.dart';
import 'package:pardon_us/screens/quiz_screens/mcqs_create_screen.dart';
import 'package:pardon_us/screens/quiz_screens/teacher_upload_quiz_screen.dart';
import 'package:pardon_us/screens/participants.dart';
import 'package:provider/provider.dart';


class QuizCard extends StatefulWidget {
  String quizTitle,dueTime,dueDate;
  String filestatus,participantStatus,docId,imgUrl;
  bool lock;
  QuizCard(this.quizTitle,this.dueDate,this.dueTime,this.filestatus,this.participantStatus,this.docId,this.imgUrl,this.lock);
  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  MediaQueryData queryData;
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
                          child: Text(widget.quizTitle,
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

                        ),
                        ),
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
        if(!widget.lock) {
          Provider.of<QuizModel>(context, listen: false).addQuizDetails(
              widget.quizTitle, widget.dueTime, widget.dueDate, widget.imgUrl);
          if (widget.filestatus == 'mcqs' &&
              widget.participantStatus == 'Student') {
            Navigator.push(
                context, FadeRoute(page: AttemptMCQS(docId: widget.docId,)));
          }
          else if (widget.filestatus == 'mcqs' &&
              widget.participantStatus == 'Teacher') {
            Navigator.push(context, FadeRoute(page: CreateMcqs()));
          }
          else if (widget.filestatus == 'file' &&
              widget.participantStatus == 'Student') {
            Navigator.push(context, FadeRoute(page: UploadQuiz(widget.docId)));
          }
          else if (widget.filestatus == 'file' &&
              widget.participantStatus == 'Teacher') {
            Navigator.push(context, FadeRoute(page: TeacherUploadQuiz()));
          }
          else {
            Navigator.push(context, FadeRoute(page: Participants()));
          }
        }
        else{
          AlertBoxes _alert=AlertBoxes();
          _alert.simpleAlertBox(context, Text('Quiz Locked'), Text('Either you have attempted this quiz or due time is over.'), (){
            Navigator.pop(context);
          });
        }
      },
    );
  }
}
