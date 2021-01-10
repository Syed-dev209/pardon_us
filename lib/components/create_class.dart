import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/models/class_methods.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pardon_us/screens/start_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShowClassDialogs{

  ClassMethods obj= new ClassMethods();
  // String getClassCode(){
  //   return classCode.text;
  // }
  Future<Widget> displayJoinClassDialog(BuildContext context,String userName,String email)async{
    GlobalKey<FormState> _key= GlobalKey<FormState>();
    TextEditingController classCode = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Join a class'),
            content: Form(
              key: _key,
              child: TextFormField(
                controller: classCode,
                decoration: InputDecoration(hintText: "Enter class code here"),
                validator: RequiredValidator(errorText: 'Do not leave this blank'),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('Join',
                  style: TextStyle(
                      color: Colors.white
                  ),),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)
                ),
                onPressed: ()async{
                  try{
                    if(_key.currentState.validate()) {
                      String joined = await obj.joinClass(
                          classCode: classCode.text,
                          participantName: userName,
                          email: email);
                      if (joined == 'enter') {
                        print('class joined');
                          classCode.clear();
                        Navigator.of(context).pop();
                      }
                      else if(joined=='Member'){
                        print('You are already a member');
                      }
                      else if(joined=='Teacher'){
                        print('You are the Teacher');
                      }
                      else{
                        print('class not exist');
                      }
                    }
                  }
                  catch(e){
                    print(e);
                  }
                },
              ),
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<Widget> displayDialog(BuildContext context,String userName,String email) async {
    GlobalKey<FormState> _key= GlobalKey<FormState>();
    TextEditingController className = TextEditingController();
    TextEditingController imageURl = TextEditingController();
    PlatformFile _image;
    print('email:= $email)');

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Class credentials'),
            content: Container(
              height: 200.0,
              width: 300.0,
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: className,
                        decoration: InputDecoration(hintText: "Enter class name"),
                        validator: RequiredValidator(errorText: 'This can\'t be blank'),
                      ),
                    ),
                    //SizedBox(height: -10.0,),
                    Expanded(
                      child: TextFormField(
                        controller: imageURl,
                        decoration: InputDecoration(hintText: "Enter class image url"),
                        validator: RequiredValidator(errorText: 'This can\'t be blank'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('Create',
                  style: TextStyle(
                      color: Colors.white
                  ),),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)
                ),
                onPressed: ()async{
                  try {
                    String classCode = getRandomString(4);
                    if(_key.currentState.validate()) {
                      bool created = await obj.createClass(
                          title: className.text,
                          classCode: classCode,
                          imageUrl: imageURl.text,
                          participantName: userName,
                          email: email
                      );
                      if (created) {
                        className.clear();
                        imageURl.clear();
                      _onButtonAlertPressed(context, 'Class Created Successfully', 'Your class code: $classCode');
                      }
                    }
                  }
                  catch(e){
                    print(e);
                  }

                  print(className.text);
                },
              ),
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
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
                context, FadeRoute(page:Start()));
          },
        )
      ]
  )
      .show();
}


