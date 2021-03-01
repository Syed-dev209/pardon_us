import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/fade_transition.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/assignments_screens/gradeStudentAssignment.dart';
import 'package:provider/provider.dart';

class StudentAssignmentAttemptList extends StatefulWidget {
  String assDocId;
  StudentAssignmentAttemptList({this.assDocId});
  @override
  _StudentAssignmentAttemptListState createState() => _StudentAssignmentAttemptListState();
}

class _StudentAssignmentAttemptListState extends State<StudentAssignmentAttemptList> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Students List',style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 10.0),
            child: StreamBuilder(
              stream: _firestore.collection('assignments').doc(Provider.of<UserDetails>(context,listen: false).currentClassCode).collection('assignment').doc(widget.assDocId).collection('attemptedBy').snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasError){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(!snapshot.hasData)
                  {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                final students = snapshot.data.docs;
                List<ListTile> stdTiles=[];
                for(var std in students)
                  {
                    stdTiles.add(studentAssignmentTile(context,std.id, std.data()['name'], std.data()['dateTime'],std.data()['fileUrl'], widget.assDocId));
                  }
                return stdTiles.isNotEmpty? Column(
                  children: stdTiles,
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.warning_amber_outlined,color: Colors.redAccent,size: 28.0,),
                    Text('None of the students has \nsubmitted the assignment.',style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18.0
                    ),),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
Widget studentAssignmentTile(context,String stdAssId,String name, String date,String fileUrl,String assDocId){
  return ListTile(
    onTap: (){
      Navigator.push(context, FadeRoute(page: GradeStudentAssignment(stdDocId: stdAssId,name: name,file: fileUrl,assDocId: assDocId,date: date,)));
    },
    leading: CircleAvatar(
      backgroundColor: Colors.indigo,
      child:Text( name[0],style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20.0
      ),),
    ),
    title: Text(name),
    //subtitle: Text(DateTime.parse(date).toLocal().toString().split(' ')[0]),
    trailing: Icon(Icons.arrow_forward_rounded,color: Colors.indigo,size: 28.0,),
  );
}