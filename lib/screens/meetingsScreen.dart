import 'package:flutter/material.dart';

class MeetingScreen extends StatefulWidget {
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 12.0,vertical: 13.0),
        child: Column(
          children: [
            TextFormField(
              decoration:  InputDecoration(
                  labelText: 'Meeting Code',
                  border: OutlineInputBorder(),
                  hintText: 'Enter meeting code here...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical:2.0)
              ),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              child: Text('Start Meeting'),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)
              ),
              onPressed: (){
                print('Start meeting pressed pressed');
              },
            ),
            SizedBox(height: 20.0,),
            SizedBox(height: 30.0,child: Divider(color: Colors.black26,),width: 300.0,),
            SizedBox(height: 20.0,),
            ListTile(
              leading: Image.asset('images/csv.png'),
              title: Text('Attendance Report'),
              subtitle: Text('Date:- 20/12/2010 Time:- 40:00 min'),
            )

          ],
        ),
      ),
    );
  }
}
