import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/models/connectivity.dart';
import 'package:pardon_us/models/login_methods.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/register_user.dart';
import 'package:pardon_us/screens/start_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key=GlobalKey<FormState>();
  MediaQueryData queryData;
  ScaleRoute route;
  bool showSpinner=false,isLoggedIn=false;
  LogInMethods _login;
  final emailController = TextEditingController();
  final passController= TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String email,name,imageURl,uid;

  Future<void> getUser(String checkEmail)async {
   final user = await _firestore.collection('user').where('email',isEqualTo: checkEmail).get();
   for(var data in user.docs)
     {
       email=data.data()['email'];
       name=data.data()['name'];
       imageURl=data.data()['profile'];
       uid=data.id;
     }
   print('at log in page:- '+email+name+imageURl+uid);
  }
  @override
  void dispose() {
    emailController.clear();
    passController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      Future<bool> onWillPop() {
        return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm Exit?',
                style: new TextStyle(color: Colors.black, fontSize: 20.0)),
            content: new Text(
                'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  // this line exits the app.
               SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop');
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
    queryData=MediaQuery.of(context);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              height: queryData.size.height,
              width: queryData.size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/blueBf.png'),
                    fit: BoxFit.fill
                )
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2,sigmaY: 2),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Image.asset('images/logo_transparent.png',height:300.0,width:300.0,),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 7.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Required'),
                                    EmailValidator(errorText: 'Not a valid Email')
                                  ]),
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    icon: Icon(Icons.email),
                                    labelText: 'Email',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Required'),
                                    MinLengthValidator(6, errorText: 'Too small'),
                                    MaxLengthValidator(10, errorText: 'Password too long')
                                  ]),
                                  obscureText: true,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    icon: Icon(Icons.remove_red_eye),
                                    labelText: 'Password',
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passController,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 13.0, horizontal: 30.0),
                                      child: Center(
                                        child: Text(
                                          'Log In',
                                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                                        ),
                                      ),
                                      elevation: 5.0,
                                      color: Colors.blue,
                                      splashColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50.0)),
                                      onPressed: () async{
                                        InternetConnectivity checkNet=new InternetConnectivity();
                                        try{
                                          bool net=await checkNet.checkConnection();
                                          if(!net)
                                            {
                                              _onBasicAlertPressed(context, 'No Internet Connection', 'Please check your connection before login');
                                            }
                                          print('email=${emailController.text},pass=${passController.text}');
                                          if (_key.currentState.validate()) {
                                            setState(() {
                                              showSpinner = true;
                                            });
                                            final user = await _auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
                                            if(user!=null){
                                             await getUser(emailController.text);
                                             Provider.of<UserDetails>(context,listen: false).setUser(name, email, uid, imageURl);
                                              print(email+',,,'+name);
                                              print('logged in');
                                              Navigator.push(context, ScaleRoute(page: Start()));
                                            }
                                            setState(() {
                                              showSpinner=false;
                                            });

                                          }
                                        }
                                        catch(e){
                                          _onBasicAlertPressed(context, 'ERROR', 'Please Register yourself before login');
                                          setState(() {
                                            showSpinner=false;
                                          });
                                          print(e);
                                        }
                                        //Navigator.push(context, ScaleRoute(page:Start()));
                                       },
                                    ),

                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 13.0, horizontal: 30.0),
                                      child: Center(
                                        child: Text(
                                          'Register',
                                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                                        ),
                                      ),
                                      elevation: 5.0,
                                      color: Colors.blue,
                                      splashColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50.0)),
                                      onPressed: () {
                                        Navigator.push(context, ScaleRoute(page:RegisterUser()));
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 30.0,
                                  child: Divider(color: Colors.black26,),
                                ),
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
                                          'Log in with Google',
                                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    elevation: 5.0,
                                    color: Colors.blue,
                                    splashColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0)),
                                    onPressed: () async{
                                      InternetConnectivity checkNet=new InternetConnectivity();
                                      try {
                                        bool net=await checkNet.checkConnection();
                                        if(!net)
                                        {
                                          _onBasicAlertPressed(context, 'No Internet Connection', 'Please check your connection before login');
                                        }
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        _login = new LogInMethods();
                                        String check = await _login.signinGoogle();

                                        if(check!='false'){
                                         await getUser(check);
                                          Provider.of<UserDetails>(context,listen: false).setUser(name, email, uid, imageURl);
                                          Navigator.push(context, ScaleRoute(page:Start()));
                                          setState(() {
                                            showSpinner=false;
                                          });
                                        }
                                        else{
                                          _onBasicAlertPressed(context, 'Error','Please register yourself before log in');
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
                                SizedBox(
                                  height: 10.0,
                                ),

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: onWillPop,
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