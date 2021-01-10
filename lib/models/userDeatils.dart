import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
class UserDetails extends ChangeNotifier{
  String _userName,_email,_photoUrl,_uid,_participantStatus,_classCode;

  String get username{
    return _userName;
  }
  String get Useremail{
    return _email;
  }
  String get userpicture{
    return _photoUrl;
  }
  String get UserParticipantStatus{
    return _participantStatus;
  }
  String get currentClassCode{
    return _classCode;
  }
  String get Userid{
    return _uid;
  }

  setUser(String name,mail,id,photo){
    _userName=name;
    _email=mail;
    _uid=id;
    _photoUrl=photo;
    notifyListeners();
  }

  setUserClassStatus(String classcode,String status){
    _classCode=classcode;
    _participantStatus=status;
    notifyListeners();

  }

}