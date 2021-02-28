import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:provider/provider.dart';

class StudentMcqsQuizReport extends StatefulWidget {
  String quizDocId, stdDocId;

  StudentMcqsQuizReport({this.quizDocId, this.stdDocId});

  @override
  _StudentMcqsQuizReportState createState() => _StudentMcqsQuizReportState();
}

class _StudentMcqsQuizReportState extends State<StudentMcqsQuizReport> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> questions = [];
  List<String> corrAns = [];
  List<String> stdAns = [];
  List<ListTile> tiles = [];
  int numOfQuestions = 0;
  String name;
  DateTime submittedTime;
  String marks;

  void getStudentAnswers() async {
    final stdData = await _firestore
        .collection('quizes')
        .doc(Provider.of<UserDetails>(context, listen: false).currentClassCode)
        .collection('quiz')
        .doc(widget.quizDocId)
        .collection('attemptedBy')
        .doc(widget.stdDocId)
        .get();
    name = stdData.data()['name'];
    marks=stdData.data()['marksObtained'];
    submittedTime = DateTime.parse(stdData.data()['dateTime']);
    for (int i = 0; i < questions.length; i++) {
      stdAns.add(stdData.data()['ans$i']);
    }
  }

  buildQuesAnsResultTile(String ques, String corAns, String ans) {
    tiles.add(ListTile(
      title: Text(ques),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Correct Answer: $corrAns'),
          SizedBox(
            height: 5.0,
          ),
          Text('Students Answer: $ans')
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Result',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: StreamBuilder(
              stream: _firestore
                  .collection('quizes')
                  .doc(Provider.of<UserDetails>(context, listen: false)
                      .currentClassCode)
                  .collection('quiz')
                  .doc(widget.quizDocId)
                  .collection('questions')
                  .snapshots(),
              builder: (context, snapshot1) {
                if (!snapshot1.hasData) {
                  return Center(
                    child: Text('Not available'),
                  );
                }
                if (snapshot1.hasError) {
                  return Center(child: CircularProgressIndicator());
                }
                final data = snapshot1.data.docs;
                for (var ques in data) {
                  questions.add(ques.data()['question']);
                  corrAns.add(ques.data()['corrAns']);
                  numOfQuestions = numOfQuestions + 1;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Name',
                      style: TextStyle(fontSize: 16.0, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Submitted at',
                      style: TextStyle(fontSize: 16.0, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      '${submittedTime.toLocal().toString().split(' ')[0]}, ${submittedTime.hour}:${submittedTime.minute}',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      children: tiles,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Marks Obtained by Student',
                      style: TextStyle(fontSize: 16.0, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      marks,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Attention: Marks have been calculated by system itself.',
                      style: TextStyle(fontSize: 16.0, color: Colors.red),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
