import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/quiz_screens/gradeStudentQuizFile.dart';
import 'package:pardon_us/screens/quiz_screens/studentMcqsQuizReport.dart';
import 'package:provider/provider.dart';

class StudentQuizList extends StatefulWidget {
  String quizDocId;
  StudentQuizList({this.quizDocId});
  @override
  _StudentQuizListState createState() => _StudentQuizListState();
}

class _StudentQuizListState extends State<StudentQuizList> {
  FirebaseFirestore _firestore= FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Students List',style: TextStyle(
          color: Colors.white,
          fontSize: 20.0
        ),),
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 10.0),
          child: StreamBuilder(
            stream: _firestore.collection('quizes').doc(Provider.of<UserDetails>(context,listen: false).currentClassCode).collection('quiz').doc(widget.quizDocId).collection('attemptedBy').snapshots(),
            builder: (context,snapshot)
            {
              if(!snapshot.hasData){
                return Center(
                  child: Text('No students has attempted quiz yet.'),
                );
              }
              if(snapshot.hasError)
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              if(snapshot.connectionState==ConnectionState.waiting)
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              final data = snapshot.data.docs;
              List<ListTile> students=[];
              for(var std in data){
                if(std.data()['type']=='mcqs')
                  {
                    students.add(studentMcqsTile(context, std.id,std.data()['name'], std.data()['dateTime'], std.data()['marksObtained'],widget.quizDocId));
                  }
                else {
                  students.add(studentFileTile(context, std.id, std.data()['name'],
                      std.data()['dateTime'], std.data()['fileUrl'],
                      widget.quizDocId));
                }
              }
              return Column(
                children: students,
              );
            },
          ),
        ),
      ),
    ),
    );
  }
}

Widget studentFileTile(context,String id, String name,String date,String fileUrl,String quizDocId){
  return ListTile(
    onTap: (){
      Navigator.push(context,FadeRoute(page: GradeStudentQuiz(name: name,date: date,file: fileUrl,docId: id,quizDocId: quizDocId,)));
    },
    leading: CircleAvatar(
      backgroundColor: Colors.indigo,
      child: Text(name[0],style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold
      ),),
    ),
    title: Text(name),
    trailing: Icon(Icons.arrow_forward_rounded,color: Colors.indigo,size: 28.0,),
  );
}
Widget studentMcqsTile(context,String id, String name,String date,String marks,String quizDocId){
  return ListTile(
    onTap: (){
      Navigator.push(context,FadeRoute(page: StudentMcqsQuizReport(stdDocId: id,quizDocId: quizDocId,)));
    },
    leading: CircleAvatar(
      backgroundColor: Colors.indigo,
      child: Text(name[0],style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
      ),),
    ),
    title: Text(name),
    trailing: Icon(Icons.arrow_forward_rounded,color: Colors.indigo,size: 28.0,),
  );
}
