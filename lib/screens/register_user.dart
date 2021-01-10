import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/models/connectivity.dart';
import 'package:pardon_us/models/login_methods.dart';
import 'package:pardon_us/screens/login_page.dart';

import 'package:rflutter_alert/rflutter_alert.dart';


class RegisterUser extends StatefulWidget {
  MediaQueryData queryData;
  File _image;
  LogInMethods login;
  bool uploaded=false;
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController= TextEditingController();
  bool showSpinner=false;
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    widget.queryData= MediaQuery.of(context);
    widget.login= LogInMethods();
    return Scaffold(
      appBar: AppBar(
        title: Text('Pardon US'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Container(
            height: widget.queryData.size.height,
            width: widget.queryData.size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 20.0),
                child: widget.uploaded?
                    Center(
                      child: AlertDialog(
                        title: new Text("WELCOME"),
                        content: new Text(
                          "Registered Successfully. \n Proceed to Login page",
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Proceed"),
                            onPressed: () {
                              Navigator.push(context, FadeRoute(page: LoginPage()));
                            },
                          ),
                        ],
                      ),
                    )
                    :Column(
                  children: [
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        CircleAvatar(
                          radius: 100.0,
                          backgroundColor: Colors.white,
                          backgroundImage: widget._image==null? AssetImage('images/profile.png'):FileImage(widget._image),
                        ),

                        Padding(
                          padding:EdgeInsets.only(left: 135.0,top: 140.0),
                          child: GestureDetector(
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                              child: Icon(Icons.camera_alt,size: 20,color: Colors.white,),
                            ),
                            onTap: () async {
                              final picked=await widget.login.chooseProfileImage();
                              setState(() {
                                widget._image=picked;
                              });


                             },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30.0,),

                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          hintText: 'Enter full name here',
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                      ),
                    ),
                    SizedBox(height:10.0),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          hintText: 'Enter Email address',
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                      ),
                    ),
                    SizedBox(height:10.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          hintText: 'Enter Password',
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
                      ),
                    ),
                    SizedBox(height: 50.0,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:80.0,vertical: 5.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: ()async {
                            InternetConnectivity checkNet= new InternetConnectivity();
                            try {
                              bool net=await checkNet.checkConnection();
                              if(!net){
                                _onBasicAlertPressed(context, 'No Internet Connection', 'Please check your internet connection before registering');
                              }
                              setState(() {
                                showSpinner=true;
                              });
                              print(passwordController.text);
                              String check = await widget.login.registerUser(
                                  emailController.text, passwordController.text,
                                  nameController.text, widget._image);
                              if (check=='created') {
                                setState(() {
                                  showSpinner=false;
                                  widget.uploaded=true;
                                });
                              }
                              else{
                                _onBasicAlertPressed(context, 'ERROR', 'This user already exist.');
                                setState(() {
                                  showSpinner=false;
                                });
                              }
                            }
                            catch(e){
                              _onBasicAlertPressed(context, 'ERROR','Something went wrong. Please try again later');
                              setState(() {
                                showSpinner=false;
                              });
                              print(e);
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors:[Color(0xff374ABE),Color(0xff64B6FF)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Register",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,child: Text('OR'),),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/google-logo.png',height:25.0,width: 20.0,),
                            SizedBox(width:9.0,),
                            Text(
                              'Register with Google',
                              style: TextStyle(fontSize: 20.0, color: Colors.white),
                            ),
                          ],
                        ),
                        elevation: 5.0,
                        color: Colors.indigo,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () async{
                          InternetConnectivity checkNet = InternetConnectivity();
                          try {
                            bool net = await checkNet.checkConnection();
                            if(!net){
                              _onBasicAlertPressed(context, 'No Internet Connection', 'Please check your internet connection before registering');
                            }
                            setState(() {
                              showSpinner = true;
                            });
                            widget.login = new LogInMethods();
                            String isLoggedIn = await widget.login.loginGoogle();
                            if(isLoggedIn=='created'){
                              setState(() {
                                showSpinner=false;
                                widget.uploaded=true;
                              });
                            }
                            else{
                              _onBasicAlertPressed(context, 'ERROR', 'This user already exist.');
                              setState(() {
                                showSpinner=false;
                              });
                            }

                            setState(() {
                              showSpinner = false;
                            });
                          }
                          catch(e){
                            setState(() {
                              _onBasicAlertPressed(context, 'ERROR', 'Something went wrong please try again later.');
                              showSpinner=false;
                            });
                          }
                        },
                      ),
                    ),
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
_onBasicAlertPressed(context,String title,String description) {
  Alert(
      context: context,
      title: title,
      desc: description)
      .show();
}
