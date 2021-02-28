import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/components/assignmnet_card.dart';
import 'package:pardon_us/components/quiz_card.dart';
import 'package:pardon_us/models/assignmentModel.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/assignments_screens/teacher_assignment_upload.dart';
import 'package:provider/provider.dart';
class AssignmentScreen extends StatefulWidget {
  String participantStatus;
  AssignmentScreen({this.participantStatus});
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  FirebaseFirestore _firestore;
  List<ListTile> assignmentCards=[];
  Widget buildTile(String title,String date,String time,String url){
    return ListTile(
      title: AssignmentCard(title,date,time,url),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore=FirebaseFirestore.instance;
  }
  @override
  Widget build(BuildContext context) {
    print(widget.participantStatus);
    return  Stack(
        children:[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: [
                widget.participantStatus=='Teacher'?
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    QuizCard('Students list attempted assignmnets','Date','Time','Mcqs','Show Participants',"","",false),
                  ],
                ):
               StreamBuilder<QuerySnapshot>(
                 stream: _firestore.collection('assignments').doc(Provider.of<UserDetails>(context,listen: false).currentClassCode).collection('assignment').snapshots(),
                 builder: (context,snapshot){
                   if(!snapshot.hasData)
                     {
                       return Center(
                         child: CircularProgressIndicator(backgroundColor: Colors.indigo,),
                       );
                     }
                   if(snapshot.hasError){
                     return Center(
                       child: Text('Error while loading assignments'),
                     );
                   }
                   final assDetails=snapshot.data.docs;
                   for(var ad in assDetails){
                     String title=ad.data()['title'];
                     String date=ad.data()['date'];
                     String time=ad.data()['time'];
                     String url=ad.data()['imageUrl'];
                     assignmentCards.add(buildTile(title,date,time,url));
                   }

                   return    Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children:assignmentCards,
                   );
                 },
               )

              ],
            ),
          ),

          widget.participantStatus=='Teacher'?
          Padding(
            padding: EdgeInsets.only(bottom: 70.0,right: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: FractionalOffset.bottomRight,
                  child:  GestureDetector(
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                          borderRadius: BorderRadius.all(Radius.circular(30.0))
                      ),
                      child: Icon(Icons.file_upload,size: 27,color: Colors.white,),
                    ),
                    onTap: (){
                      Navigator.push(context, FadeRoute(page: TeacherUploadAssignment()));
                    },
                  )
                ),
              ],
            ),
          ): Container()

        ]
    );
  }
}
