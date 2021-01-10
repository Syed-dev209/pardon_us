import 'package:flutter/material.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/class_screen.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddQuestions extends StatefulWidget {
  QuizModel quizModel=QuizModel();
  @override
  _AddQuestionsState createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  final question= TextEditingController();
  final correct= TextEditingController();
  final opt1= TextEditingController();
  final opt2= TextEditingController();
  final opt3= TextEditingController();
  final points= TextEditingController();
  GlobalKey<FormState> _key=GlobalKey<FormState>();
  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Confirm Exit?',
              style: new TextStyle(color: Colors.black, fontSize: 20.0)),
          content: new Text(
              'All your data will be lost. Are you sure you want to go back?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Provider.of<QuizModel>(context,listen: false).clearLists();
                Navigator.push(context, ScaleRoute(page: ClassScreen()));
              },
              child:
              new Text('Yes', style: new TextStyle(fontSize: 18.0)),
            ),
            new FlatButton(
              onPressed: () => Navigator.pop(context), // this line dismisses the dialog
              child: new Text('No', style: new TextStyle(fontSize: 18.0)),
            )
          ],
        ),
      ) ??
          false;

    }
    queryData= MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('PARDON US'),
      ),
      body: WillPopScope(
        child: SafeArea(
          child: Container(
            height: queryData.size.height,
            width: queryData.size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 9.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: question,
                        validator: RequiredValidator(errorText: 'Fill this field'),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Question',
                            border: OutlineInputBorder(),
                            hintText: 'Enter your question here...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: correct,
                        validator: RequiredValidator(errorText: 'you can not leave this blank'),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Correct Answer',
                            border: OutlineInputBorder(),
                            hintText: 'Enter Correct answer here',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: opt1,
                        validator: RequiredValidator(errorText: 'you can not leave this blank'),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Option 1',
                            border: OutlineInputBorder(),
                            hintText: 'Enter first option',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Expanded(
                      child: TextFormField(
                        controller: opt2,
                        validator: RequiredValidator(errorText: 'you can not leave this blank'),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Option 2',
                            border: OutlineInputBorder(),
                            hintText: 'Enter second option',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Expanded(
                      child: TextFormField(
                        controller: opt3,
                        validator: RequiredValidator(errorText: 'you can not leave this blank'),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Option 3',
                            border: OutlineInputBorder(),
                            hintText: 'Enter third option',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Expanded(
                      child: TextFormField(
                        controller: points,
                        validator: RequiredValidator(errorText: 'you can not leave this blank'),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Points',
                            border: OutlineInputBorder(),
                            hintText: 'Points For this Question',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                        ),
                      ),
                    ),


                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          OutlineButton(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text('Submit',
                              style: TextStyle(
                               fontSize: 18.0
                              ),),
                            ),
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.0,
                              style: BorderStyle.solid
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            onPressed: ()async {
                              Provider.of<QuizModel>(context,listen: false).printAll();
                             String check= await Provider.of<QuizModel>(context,listen:false).submitQuiz(Provider.of<UserDetails>(context,listen: false).currentClassCode);
                             if(check=='submitted')
                               {
                                 _onButtonAlertPressed(context, 'Quiz created', 'Quiz was created successfully.');
                               }
                             else if(check=='empty'){
                               _onBasicAlertPressed(context, 'No questions added', 'In order to submit please add the question first then press submit.');
                             }
                              print(' submit pressed');
                            },
                          ),
                          SizedBox(width: 12.0,),
                          RaisedButton(
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text('Add Question',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0
                              ),),
                            ),
                            onPressed: (){
                              if(_key.currentState.validate()){
                               bool check = Provider.of<QuizModel>(context,listen: false).addQuizQuestions(question: question.text,one: opt1.text,two: opt2.text,three: opt3.text,correct: correct.text,points: points.text);
                                if(check){
                                  Navigator.push(context, ScaleRoute(page: AddQuestions()));
                                }
                                else{
                                  _onBasicAlertPressed(context, 'Where are your glasses ?', 'Correct answer is not included in options list.');
                                }
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

          ),
        ),
        onWillPop: onWillPop,
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
            Provider.of<QuizModel>(context,listen: false).clearLists();
            Navigator.push(context, ScaleRoute(page: ClassScreen()));
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
