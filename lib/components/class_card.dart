import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/class_screen.dart';
import 'package:provider/provider.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/models/class_methods.dart';

class ClassCard extends StatefulWidget {
  String className,teacher,imageURL;
  String participantStatus,classCode,userName;
  ClassCard(this.userName,this.classCode,this.className,this.teacher,this.participantStatus,this.imageURL);
  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  ClassMethods classMethods;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Container(
              height: 120.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // border: Border.all(
                //   color:  Color(0xFF303F9F),
                //   width: 2.0
                // )
              ),
              child: Padding(
                padding: EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(widget.imageURL==null?'https://slm-assets.secondlife.com/assets/1403881/lightbox/078da90689600c880b31e6c65dfcc1e3.jpg?1277229557':widget.imageURL),

                        radius:40.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0,top: 10.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(widget.className,style: TextStyle(
                            color: Colors.black54,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0
                          ),),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 200.0,
                          child: Divider(color: Colors.black26,),
                        ),

                        Expanded(
                          child: Text(widget.teacher,style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,

                          ),),
                        ),

                      ],
                      ),
                    )


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        Provider.of<UserDetails>(context,listen: false).setUserClassStatus(widget.classCode, widget.participantStatus);
      Navigator.push(context,ScaleRoute(page: ClassScreen()));
      },
      onLongPress: (){
        showDialog(
          context: context,
          builder: (context)=>AlertDialog(
            title: Text(widget.participantStatus=='Student'?'Do you really want to unroll from class ?':'Do you really wish to delete the class?'),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: ()async{
                  classMethods= ClassMethods();
                  if(widget.participantStatus=='Student'){
                    try {
                      bool check = await classMethods.exitClass(
                          widget.classCode, Provider
                          .of<UserDetails>(context, listen: false)
                          .Useremail);
                      if (check) {
                   Navigator.pop(context);
                      }
                    }
                    catch(e){
                      print(e);
                    }
                  }
                  else{
                    try{
                      setState(() {
                        showSpinner=true;
                      });
                      bool check=await classMethods.deleteClass(widget.classCode);
                      if (check) {
                        Navigator.pop(context);
                      }
                    }
                    catch(e){
                      print(e);
                    }
                  }

                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          )
        );
      },
    );
  }
}


