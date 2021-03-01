import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel{
  String _title,_url,_date,_time,_docId;

  setAssignmentDetails({String title,String time,String date,String fileUrl,String docId}){
    _title=title;
    _url=fileUrl;
    _time=time;
    _date=date;
    _docId=docId;
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
  String get docId{
    return _docId;
  }
}