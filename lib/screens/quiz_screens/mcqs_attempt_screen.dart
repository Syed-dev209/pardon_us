import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/mcqstepsContent.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/class_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AttemptMCQS extends StatefulWidget {
  String docId;

  AttemptMCQS({this.docId});

  @override
  _AttemptMCQSState createState() => _AttemptMCQSState();
}

class _AttemptMCQSState extends State<AttemptMCQS> {
  int _currentstep = 0, index = 0, result = 0;
  bool complete = false;
  FirebaseFirestore _firestore;
  List<Step> stepsCont = [];

  next() async {
    // _currentstep + 1 != stepsCont.length
    //     ? goTo(_currentstep + 1)
    //     : setState(() => complete = true);
    index++;
    print('Step length: ${stepsCont.length}');
    print('Current step: $_currentstep');
    if (_currentstep + 1 != stepsCont.length) {
      goTo(_currentstep + 1);
    } else {
      result = Provider.of<QuizModel>(context, listen: false).checkAnswers();
      print('result: $result');
      bool check = await Provider.of<QuizModel>(context, listen: false)
          .submitStudentMcqResult(context, result,widget.docId);
      if (check) {
        setState(() {
          complete = true;
        });
      }
      else
        {
          print('Failed');
        }
    }
  }

  cancel() {
    if (_currentstep > 0) {
      goTo(_currentstep - 1);
    }
  }

  goTo(int step) {
    Provider.of<QuizModel>(context, listen: false).setStepCount(step);
    _currentstep = step;
  }

  Step buildSteps(
      String ques, String opt1, String opt2, String opt3, int index) {
    print(widget.docId);
    return Step(
        title: Text('Question $index'),
        content: StepContent(ques, opt1, opt2, opt3, index - 1));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stepsCont.clear();
    _firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<QuizModel>(context, listen: false).setStepCount(0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF303F9F),
        // leading: Icon(Icons.list),
        title: Text('PARDON US'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            complete
                ? Expanded(
                    child: Center(
                      child: AlertDialog(
                        title: new Text("Quiz Submitted"),
                        content: new Text(
                          "Tada! You got $result correct answers",
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              setState(() => complete = false);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ClassScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('quizes')
                        .doc(Provider.of<UserDetails>(context, listen: false)
                            .currentClassCode)
                        .collection('quiz')
                        .doc(widget.docId)
                        .collection('questions')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.indigo,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Something gone wrong'),
                        );
                      }
                      final quizQues = snapshot.data.docs;
                      int i = 0;
                      for (var qq in quizQues) {
                        i++;
                        stepsCont.add(buildSteps(
                            qq.data()['question'],
                            qq.data()['opt1'],
                            qq.data()['opt2'],
                            qq.data()['op3'],
                            i));
                        Provider.of<QuizModel>(context, listen: false)
                            .setCorrAns(qq.data()['corrAns']);
                      }
                      print(stepsCont.length);
                      return Expanded(child: Consumer<QuizModel>(
                          builder: (context, details, child) {
                        return Stepper(
                            currentStep: details.getStepCount,
                            onStepContinue: next,
                            onStepCancel: cancel,
                            steps: stepsCont);
                      }));
                    })
          ],
        ),
      ),
    );
  }
}

_onButtonAlertPressed(context, String title, String description) {
  Alert(context: context, title: title, desc: description, buttons: [
    DialogButton(
      child: Text(
        'Proceed',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.indigo,
      onPressed: () {
        Navigator.push(context, FadeRoute(page: ClassScreen()));
      },
    )
  ]).show();
}

// Column(
// children: stepsCont,
// );
