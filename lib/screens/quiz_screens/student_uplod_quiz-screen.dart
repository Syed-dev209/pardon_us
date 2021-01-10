import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/models/files_upload_Model.dart';
import 'package:pardon_us/models/urlLauncher.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../class_screen.dart';
import 'package:pardon_us/models/managing_directory.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadQuiz extends StatefulWidget {
  String docId;

  UploadQuiz(this.docId);

  @override
  _UploadQuizState createState() => _UploadQuizState();
}

class _UploadQuizState extends State<UploadQuiz> {
  Launcher _launch;
  FilesUpload _filesUpload;
  Directory _dir;
  PlatformFile _file;
  bool fileSelected = false, isPdf = false, showSpinner = false;
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime day = DateTime.parse(
        Provider.of<QuizModel>(context, listen: false).quizDeatils['date']);
    return Scaffold(
      appBar: AppBar(
        title: Text('PARDON US'),
      ),
      body: SafeArea(
          child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(
                  Icons.message,
                  color: Colors.red,
                ),
                title: Text(Provider.of<QuizModel>(context, listen: false)
                    .quizDeatils['title']),
                subtitle: Text('Click to download file'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                      style: TextStyle(color: Colors.green),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                        Provider.of<QuizModel>(context, listen: false)
                            .quizDeatils['time'],
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
                onTap: () async {
                  _launch = Launcher();
                  _dir = Directory();
                  try {
                    if (await canLaunch(
                        Provider.of<QuizModel>(context, listen: false)
                            .quizDeatils['imageUrl'])) {
                      await launch(
                          (Provider.of<QuizModel>(context, listen: false)
                              .quizDeatils['imageUrl']));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              SizedBox(
                height: 20.0,
                child: Divider(
                  color: Colors.blueGrey,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(color: Colors.black26, width: 1.0)),
                  child: Column(
                    children: [
                      Container(
                          height: 220.0,
                          // width: 400.0,
                          child: fileSelected
                              ? ListView(
                                  children: [
                                    ListTile(
                                      leading: isPdf
                                          ? Image.asset(
                                              'images/pdf_img.png',
                                              height: 50.0,
                                              width: 50.0,
                                            )
                                          : Image.asset(
                                              'images/doc_img.png',
                                              height: 50.0,
                                              width: 50.0,
                                            ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('File selected: ${_file.name}'),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            'Time: ',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          Text(
                                            '${dateTime.hour}:${dateTime.minute}',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text('Date: ',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Text(
                                            '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : Container()),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: IconButton(
                          onPressed: () async {
                            _dir = Directory();
                            _file = await _dir.pickFiles();
                            setState(() {
                              fileSelected = true;
                              if (_file.extension == 'pdf') {
                                isPdf = true;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.file_upload,
                            color: Colors.indigo,
                            size: 40.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 90.0),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 7.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                  color: Colors.blueAccent,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () async {
                    print(widget.docId);
                    try {
                      // Navigator.push(context, FadeRoute(page: ClassScreen()));
                      _filesUpload = FilesUpload();
                      setState(() {
                        showSpinner = true;
                      });
                      String url = await _filesUpload.uploadFile(
                          _file,
                          Provider.of<UserDetails>(context, listen: false)
                              .currentClassCode,
                          'quizSubmissions');
                      bool check = await Provider.of<QuizModel>(context,
                              listen: false)
                          .submitStudentQuizFile(context, url, widget.docId);
                      if (check) {
                        setState(() {
                          showSpinner = false;
                        });
                        _onButtonAlertPressed(
                            context, 'WOOHO !', 'Your quiz has been submitted');
                      } else {
                        _onBasicAlertPressed(
                            context, 'Error', 'Failed to upload quiz');
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      _onBasicAlertPressed(
                          context, 'Error', 'Something went wrong');
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

_onBasicAlertPressed(context, String title, String description) {
  Alert(context: context, title: title, desc: description).show();
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
