import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/date_and_time_picker.dart';
import 'package:pardon_us/models/files_upload_Model.dart';
import 'package:pardon_us/models/managing_directory.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/class_screen.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TeacherUploadQuiz extends StatefulWidget {
  String participantStatus;

  TeacherUploadQuiz({this.participantStatus});

  @override
  _TeacherUploadQuizState createState() => _TeacherUploadQuizState();
}

class _TeacherUploadQuizState extends State<TeacherUploadQuiz> {
  MediaQueryData queryData;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _date ;
  TimeOfDay _time;
  Directory directory;
  FilesUpload upload;
  PlatformFile _file;
  bool fileSelected=false,isPdf=false,showSpinner=false,
      isDateSelected = false,
      isTimeSelected = false;
  TextEditingController quizTitle= TextEditingController();

  _chooseDate(context) async {
    DateAndTimePicker select = new DateAndTimePicker();
    final DateTime picked = await select.choosedate(context);
    if (picked != null && picked != _date)
      setState(() {
        _date = picked;
        isDateSelected=true;
      });
    if (picked == null) {
      _date = DateTime.now();
    }
  }

  _chooseTime(context) async {
    DateAndTimePicker select = new DateAndTimePicker();
    final TimeOfDay picked = await select.chooseTime(context);
    setState(() {
      _time = picked;
      isTimeSelected=true;
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 8.0),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: quizTitle,
                            validator: RequiredValidator(errorText: 'Required Field'),
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              icon: Icon(
                                Icons.title,
                              ),
                              labelText: 'Enter Quiz Title',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 60.0),
                            child: RaisedButton(
                              elevation: 3.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.0,),
                                  Text(
                                    'Choose submission date',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              color: Colors.blueAccent,
                              onPressed: () {
                                _chooseDate(context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 60.0),
                            child: RaisedButton(
                              elevation: 3.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.timer,color: Colors.white,),
                                  SizedBox(width: 8.0,),
                                  Text(
                                    'Choose submission time',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              color: Colors.blueAccent,
                              onPressed: () {
                                _chooseTime(context);
                              },
                            ),
                          ),
                            isDateSelected
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
                            SizedBox(height: 5.0),
                            isTimeSelected
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
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            height: 260.0,
                            width: 500.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  color: Colors.black26,
                                  width: 1.2
                              )
                            ),
                            child: Column(
                             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 180.0,
                                 // width: 400.0,
                                   child: fileSelected? ListView(
                                     children: [
                                       ListTile(
                                         leading: isPdf?Image.asset('images/pdf_img.png',height: 50.0,width: 50.0,)
                                             :Image.asset('images/doc_img.png',height: 50.0,width: 50.0,),
                                         title: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(quizTitle.text),
                                             Text('File selected: ${_file.name}'),
                                           ],
                                         ),
                                         subtitle: Row(
                                           children: [
                                             Text('Time: ',style: TextStyle(color: Colors.red),),
                                             Text('${_time.hour}:${_time.minute}',style: TextStyle(color: Colors.green),),
                                             SizedBox(width: 5.0,),
                                             Text('Date: ',style: TextStyle(color: Colors.red)),
                                             Text('${_date.day}/${_date.month}/${_date.year}',style: TextStyle(color: Colors.green),),
                                           ],
                                         ),
                                       )
                                     ],
                                   ):Container()
                                ),
                                Padding(
                                  padding:EdgeInsets.symmetric(horizontal: 80.0,vertical: 8.0),
                                  child: RaisedButton(
                                    elevation: 3.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.file_upload,color: Colors.white,size: 26.0,),
                                        SizedBox(width:7.0),
                                        Text(
                                          'Upload File',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    color: Colors.blueAccent,
                                    onPressed: () async {
                                      directory = Directory();
                                      upload = FilesUpload();
                                      if (
                                      isTimeSelected &&
                                          isDateSelected &&
                                          quizTitle.text.isNotEmpty) {
                                        _file = await directory.pickFiles();
                                        print(_file.name);
                                        print(_file.extension);
                                        print(_file.path);
                                        setState(() {
                                          fileSelected = true;
                                          if (_file.extension == 'pdf') {
                                            isPdf = true;
                                          }
                                        });
                                      }
                                      else {
                                        _onBasicAlertPressed(
                                            context,
                                            'Are you really a Teacher?',
                                            'You haven\'t fill the form correctly');
                                      }

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 70.0,
                          ),
                          Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                boxShadow: [BoxShadow(color: Colors.indigo)]),
                            child: IconButton(
                              icon: Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: ()async {
                                setState(() {
                                  showSpinner=true;
                                });
                                try {
                                  String fileUrl = await upload.uploadFile(
                                      _file, Provider
                                      .of<UserDetails>(context, listen: false)
                                      .currentClassCode,'quizFiles');
                                  bool check = await upload.uploadQuizDetails(
                                      quizTitle.text, _time.toString(),
                                      _date.toString(), fileUrl, Provider
                                      .of<UserDetails>(context, listen: false)
                                      .currentClassCode);
                                  if(check){
                                    setState(() {
                                      showSpinner=false;
                                    });
                                   _onButtonAlertPressed(context, 'WOOHO !', 'Quiz uploaded successfully ');

                                  }
                                  else
                                    {
                                      _onBasicAlertPressed(context, 'FAILED', 'Something went wrong');
                                    }
                                }
                                catch(e){
                                  setState(() {
                                    showSpinner=false;
                                  });
                                  _onBasicAlertPressed(context, 'ERROR', 'Something went wrong');
                                }

                              },
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
_onButtonAlertPressed(context,String title,String description) {
  Alert(
      context: context,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text('Proceed',style: TextStyle(
              color: Colors.white
          ),),
          color: Colors.indigo,
          onPressed: (){

            Navigator.push(
                context, FadeRoute(page: ClassScreen()));
          },
        )
      ]
  )
      .show();
}
_onBasicAlertPressed(context,String title,String description) {
  Alert(
      context: context,
      title: title,
      desc: description)
      .show();
}
