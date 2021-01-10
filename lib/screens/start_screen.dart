import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pardon_us/components/class_card.dart';
import 'package:pardon_us/components/drawer_item.dart';
import 'package:pardon_us/animation_transition/icon_flodable_animation.dart';
import 'package:pardon_us/components/create_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pardon_us/models/class_methods.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:provider/provider.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  String userId;
  ShowClassDialogs dailogs = new ShowClassDialogs();
  ClassMethods obj = ClassMethods();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String classCode;
  String classTitle, classTeacher,classImage;
  MediaQueryData _queryData;

Widget buildListTile(String usnam,String code,String name,String teacher,String role,String img){
  print('at start screen teacher'+teacher);
    return ListTile(
          title: ClassCard(usnam,code,name,teacher,role,img),
        );
}

 FirebaseFirestore firestore= FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    _queryData= MediaQuery.of(context);
    userId=Provider.of<UserDetails>(context,listen: false).Userid;
    print('at start screen uid='+userId);
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
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('PARDON US'),
        ),
         drawer:DrawerItem(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Consumer<UserDetails>(
              builder: (context,user,child){
                print('in consumer'+user.Userid);
                return StreamBuilder(
                  stream:firestore.collection('user').doc(user.Userid).collection('joinedClasses').snapshots(),
                  builder:(context,snapshot){
                    if(!snapshot.hasData){
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.indigo,
                        ),
                      );
                    }
                    else if(snapshot.hasError){
                      return Text('No classes to show');
                    }
                    final classData = snapshot.data.docs;
                    List<ListTile> studentClasses=[];
                    List<ListTile> myClasses=[];
                    for(var cd in classData ) {
                      classCode = cd.data()['classCode'];
                      classTitle=cd.data()['title'];
                      classTeacher=cd.data()['teacher'];
                      classImage=cd.data()['imageURL'];
                      if(classTeacher==user.username){
                        //I am the teacher
                        myClasses.add(buildListTile(user.username,classCode,classTitle,classTeacher,'Teacher',classImage));
                      }
                      else{
                        studentClasses.add(buildListTile(user.username,classCode,classTitle,classTeacher,'Student',classImage));
                      }
                    }
                    return Column(
                      children: [
                        Classes(_queryData.size.width, 'https://cdn.pixabay.com/photo/2018/09/15/16/56/teacher-3679814_960_720.jpg', 'MY CLASSES', myClasses),
                        SizedBox(height: 5.0),
                        Classes(_queryData.size.width, 'https://www.kindpng.com/picc/m/109-1097640_student-university-cartoon-hd-png-download.png', 'MY COURSES', studentClasses)


                      ],
                    );
                    // return studentClasses.isNotEmpty?
                    // ListView(
                    //   children: studentClasses,
                    // ):Container(
                    //   child:Center(
                    //     child: Text('You haven\'t joined any class yet. '),
                    //   ),
                    // );
                  } ,
                );
              },
            )
          ),
        ),
        floatingActionButton:  Consumer<UserDetails>(
          builder: (context,user,child){
            return Padding(
              padding: EdgeInsets.only(top: _queryData.size.height-150),
              child: FoldableOption(
                icon1: Icons.add,
                onTap1: (){
                  print(user.username+'/'+user.Useremail);
                  dailogs.displayDialog(context,user.username,user.Useremail);
                },
                icon2: Icons.add_shopping_cart,
                onTap2: (){
                  dailogs.displayJoinClassDialog(context,user.username,user.Useremail);

                },

              ),
            );
          }
        ),
      ),
      onWillPop: onWillPop,
    );
  }
}

Widget Classes(double width,String imagePath,String expTitle,List<ListTile> list){

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.deepPurple,Colors.blue,Colors.white],
  ).createShader(new Rect.fromLTWH(0.0,0.0, 200.0, 70.0));
  return Card(
    elevation: 3.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0)
    ),
    child: Column(
      children: [
        Container(
          width: width,
          height: 190.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(imagePath)
            )
          ),
        ),
        ExpansionTile(
          title: Text(expTitle,style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            // foreground: new Paint()..shader=linearGradient
            color: Colors.black26
          ),),
          children: [
            Column(
              children:list
            )
          ],
        )
      ],
    ),
  );

}