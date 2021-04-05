import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/alertBox.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:pardon_us/models/urlLauncher.dart';
import 'package:pardon_us/screens/quiz_screens/studentQuizAttemptList.dart';
import 'package:provider/provider.dart';

class GradeStudentQuiz extends StatefulWidget {
  String date,file,name,docId,quizDocId;
  GradeStudentQuiz({this.name,this.date,this.file,this.docId,this.quizDocId});
  @override
  _GradeStudentQuizState createState() => _GradeStudentQuizState();
}

class _GradeStudentQuizState extends State<GradeStudentQuiz> {
  TextEditingController marks=TextEditingController();
  GlobalKey<FormState> _key= GlobalKey<FormState>();
  DateTime submittedTime;
  bool showSpinner=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   submittedTime = DateTime.parse(widget.date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Grade Quiz'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 20.0),
              child: Form(
                key: _key,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student Name',style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black26
                    ),),
                    SizedBox(height: 4.0,),
                    Text(widget.name,style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 30.0,),
                    Text('Submitted at',style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black26
                    ),),
                    SizedBox(height: 4.0,),
                    Text('${submittedTime.toLocal().toString().split(' ')[0]}, ${submittedTime.hour}:${submittedTime.minute}',style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    SizedBox(height: 30.0,),
                    Text('Submitted File',style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black26
                    ),),
                    SizedBox(height: 4.0,),
                    ListTile(
                      onTap: (){
                        Launcher urlLauncher= Launcher();
                        urlLauncher.launchUrl(widget.file);
                      },
                      leading: Image(
                        image: AssetImage('images/pdf_img.png'),
                      ),
                      title: Text('File Name'),
                      subtitle: Text('Click to download file'),
                    ),
                    SizedBox(height: 30.0,),
                    TextFormField(
                      controller: marks,
                      validator: MultiValidator([
                        RequiredValidator(errorText: '*You can not leave this blank'),
                      ]),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                          labelText: 'Enter Marks',
                          border: OutlineInputBorder(),
                          hintText: 'Enter marks here',
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                      ),
                    ),

                    SizedBox(height: 50.0,),
                    Center(
                      child: RaisedButton(
                        color: Colors.indigo,
                        padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 7.0),
                        child: Text('Grade',style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                        ),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        onPressed: ()async{
                          AlertBoxes _alert=AlertBoxes();
                          if(_key.currentState.validate())
                            {
                              try {
                                setState(() {
                                  showSpinner = true;
                                });
                                bool check = await Provider.of<QuizModel>(
                                    context, listen: false).gradeStudentFileQuiz(
                                    context, widget.docId, marks.text,
                                    widget.quizDocId);
                                if(check)
                                  {
                                    setState(() {
                                      showSpinner=false;
                                    });
                                    _alert.simpleAlertBox(context, Text('Wooho!'), Text('Student has been graded'),(){
                                      Navigator.push(context, FadeRoute(page: StudentQuizList(quizDocId: widget.quizDocId,)));
                                    });
                                  }
                                else{
                                  _alert.simpleAlertBox(context, Text('ERROR'), Text('Unable to grade student'),(){
                                    Navigator.pop(context);
                                  });
                                }
                              }
                              catch(e){
                                setState(() {
                                  showSpinner=false;
                                });
                                _alert.simpleAlertBox(context, Text('ERROR'), Text('Unable to grade student'),(){
                                  Navigator.pop(context);
                                });
                              }
                              }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
