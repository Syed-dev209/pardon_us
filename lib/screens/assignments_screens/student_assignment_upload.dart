import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/alertBox.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/models/files_upload_Model.dart';
import 'package:pardon_us/models/urlLauncher.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:provider/provider.dart';
import '../class_screen.dart';
import 'package:pardon_us/models/managing_directory.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pardon_us/models/assignmentModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentUploadAssignment extends StatefulWidget {
  AssignmentModel assDetails;

  StudentUploadAssignment({this.assDetails});

  @override
  _StudentUploadAssignmentState createState() =>
      _StudentUploadAssignmentState();
}

class _StudentUploadAssignmentState extends State<StudentUploadAssignment> {
  Launcher _launch;
  Directory _dir;
  PlatformFile _file;
  bool fileSelected = false,
      isPdf = false,
      showSpinner = false;
  DateTime dateTime = DateTime.now();
  FilesUpload upload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PARDON US'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.message, color: Colors.red,),
                    title: Text(widget.assDetails.assignmentTile),
                    subtitle: Text('Click to download file'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.assDetails.dueDate,
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(height: 2.0,),
                        Text(widget.assDetails.dueTime,
                            style: TextStyle(color: Colors.green)
                        ),
                      ],
                    ),
                    onTap: () async {
                      _launch = Launcher();
                      _dir = Directory();
                      try {
                        // await _launch.launchUrl(Provider.of<QuizModel>(context,listen: false).quizDeatils['imageUrl']);
                        // bool check = await _dir.download(Provider.of<QuizModel>(context,listen: false).quizDeatils['imageUrl']);
                        // if(check==false)
                        //   {
                        //     print("Error while downloading file ");
                        //   }
                        if (await canLaunch(widget.assDetails.fileUrl)) {
                          await launch(widget.assDetails.fileUrl);
                        }
                      }
                      catch (e) {
                        print(e);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0, child: Divider(color: Colors.blueGrey,),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 400.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              color: Colors.black26,
                              width: 1.0
                          )
                      ),
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
                                          '${dateTime.day}/${dateTime
                                              .month}/${dateTime.year}',
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
                                Icons.file_upload, color: Colors.indigo,
                                size: 40.0,),
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
                          borderRadius: BorderRadius.circular(7.0)
                      ),
                      color: Colors.blueAccent,
                      child: Text('Submit',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),),
                      onPressed: () async {
                        if (fileSelected) {
                          setState(() {
                            showSpinner = true;
                          });
                          upload = FilesUpload();
                          AlertBoxes _alert=AlertBoxes();
                          bool check = await upload.submitStudentAssignment(
                              name: Provider
                                  .of<UserDetails>(context, listen: false)
                                  .username, assFile: _file,
                            classCode: Provider.of<UserDetails>(context,listen: false).currentClassCode,
                            assDocId: widget.assDetails.docId
                          );
                          if(check)
                            {
                              setState(() {
                                showSpinner=false;
                              });
                              _alert.simpleAlertBox(context, Text('Wooho!'),Text('Your assignment has been uploaded'),(){
                                Navigator.push(context, FadeRoute(page: ClassScreen()));
                              });
                            }
                          else{
                            setState(() {
                              showSpinner=false;
                            });
                            _alert.simpleAlertBox(context, Text('ERROR'),Text('Your assignment has not been uploaded'),(){
                              Navigator.pop(context);
                            });
                          }
                          
                        }
                        //Navigator.push(context, FadeRoute(page: ClassScreen()));
                      },
                    ),
                  )

                ],
              ),
            )
        ),
      ),

    );
  }
}
