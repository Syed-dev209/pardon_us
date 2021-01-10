import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardon_us/models/userDeatils.dart';

import 'package:provider/provider.dart';

class Participants extends StatelessWidget {
  FirebaseFirestore _firestore= FirebaseFirestore.instance;
  String classCode;
  @override
  Widget build(BuildContext context) {
    classCode=Provider.of<UserDetails>(context,listen: false).currentClassCode;

    Widget _buildRow(String name){
      return ListTile(
        leading: CircleAvatar(
          child: Text(name[0]),
        ),
        title: Text(name,
          style:TextStyle(
          fontSize: 18.0
        ) ,),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('PARDON US'),

      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream:_firestore.collection('classes').doc(classCode).collection('participants').snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.indigo,
                ),
              );
            }
            final participantsData = snapshot.data.docs;
            List<ListTile> participants=[];
            for(var participant in participantsData ){
              final name=participant.data()['name'];
              participants.add(_buildRow( name));
            }
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 2.0,vertical:5.0),
              children: participants,
            );
          },
        )
      ),
    );
  }
}

