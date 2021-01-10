import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel{
  String _title,_url,_date,_time;

  setAssignmentDetails({String title,String time,String date,String fileUrl}){
    _title=title;
    _url=fileUrl;
    _time=time;
    _date=date;
  }

  String get assignmentTile{
    return _title;
  }
  String get fileUrl{
    return _url;
  }
  String get dueTime{
    return _time;
  }
  String get dueDate{
    return _date;
  }
}