import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/screens/quiz_screens/add_questions_screen.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/components/date_and_time_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:provider/provider.dart';

class CreateMcqs extends StatefulWidget {
  QuizModel mcqs = QuizModel();

  @override
  _CreateMcqsState createState() => _CreateMcqsState();
}

class _CreateMcqsState extends State<CreateMcqs> {
  TextEditingController title = TextEditingController();
  TextEditingController image = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  MediaQueryData queryData;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool timeSelected = false, dateSelected = false;

  _chooseDate(context) async {
    DateAndTimePicker select = new DateAndTimePicker();
    final DateTime picked = await select.choosedate(context);
    if (picked != null && picked != _date)
      setState(() {
        _date = picked;
        dateSelected = true;
      });
    if (picked == null) {
      _date = DateTime.now();
    }
  }

  _chooseTime(context) async {
    DateAndTimePicker select = new DateAndTimePicker();
    final TimeOfDay picked = await select.chooseTime(context);
    print(picked);

    setState(() {
      _time = picked;
      timeSelected = true;
      print(_time);
    });

    if (picked == null) _time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('PARDON US'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentfocus = FocusScope.of(context);
          if (!currentfocus.hasPrimaryFocus) {
            currentfocus.unfocus();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: queryData.size.width,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
                    child: Form(
                      key: _key,
                      child: Column(
                        // mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: title,
                            validator: RequiredValidator(
                                errorText: 'This is mandatory'),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(),
                                hintText: 'Title of quiz here',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 2.0)),
                          ),
                          SizedBox(height: 18.0),
                          TextFormField(
                            controller: image,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'Image URL',
                                border: OutlineInputBorder(),
                                hintText: 'Quiz image URL (optional)',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 2.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  timeSelected
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 3.0),
                          height: 30.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Center(
                              child: Text(
                                  'Time Selected :- ${_time.hour}:${_time.minute}')),
                        )
                      : SizedBox(),
                  SizedBox(height: 5.0),
                  dateSelected
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(3.0)),
                          height: 30.0,
                          width: 200.0,
                          child: Center(
                              child: Text(
                                  'Date Selected :- ${_date.day}/${_date.month}/${_date.year}')))
                      : SizedBox(),
                  SizedBox(height: 30.0),
                  RaisedButton(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    child: Container(
                        height: 20.0,
                        width: 170.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Expanded(
                                child: Text(
                              'Choose submission time',
                              style: TextStyle(color: Colors.white),
                            )),
                          ],
                        )),
                    color: Colors.blueAccent,
                    onPressed: () {
                      _chooseTime(context);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    child: Container(
                      height: 20.0,
                      width: 170.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                              child: Text(
                            'Choose submission date',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          )),
                        ],
                      ),
                    ),
                    color: Colors.blueAccent,
                    onPressed: () {
                      _chooseDate(context);
                    },
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 9.0, horizontal: 9.0),
                          child: Text(
                            'Proceed',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0),
                          ),
                        ),
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (_key.currentState.validate() &&
                              dateSelected != false &&
                              timeSelected != null) {
                            //  widget.mcqs.addQuizDetails(title.text,'${_time.hour}/${_time.minute}','${_date.day}/${_date.month}/${_date.year}',image.text.length<=3?'https://cdn.pixabay.com/photo/2017/03/25/20/51/quiz-2174368_960_720.png':image.text);
                            Provider.of<QuizModel>(context, listen: false)
                                .addQuizDetails(
                                    title.text,
                                    '$_time',
                                    _date.toString(),
                                    image.text.isEmpty
                                        ? 'https://cdn.pixabay.com/photo/2017/03/25/20/51/quiz-2174368_960_720.png'
                                        : image.text);
                            Navigator.push(
                                context, ScaleRoute(page: AddQuestions()));
                            print('pressed');
                          } else {
                            _onBasicAlertPressed(context, 'INVALID CREDENTIALS',
                                'Make sure you have filled the form correctly');
                          }
                        },
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_onBasicAlertPressed(context, String title, String description) {
  Alert(context: context, title: title, desc: description).show();
}
