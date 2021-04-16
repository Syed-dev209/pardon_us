import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:pardon_us/models/excelServices.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:provider/provider.dart';

class MeetingController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createMeeting(context) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(
              Provider.of<UserDetails>(context, listen: false).currentClassCode)
          .collection('meetingRecord')
          .doc()
          .set({
        'DateTime': DateTime.now().toString(),
        'live': 'true',
        'fileUrl': ' '
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endMeeting(context, String filename, ExcelSheet excel) async {
    try {
      String docId = await _getCurrentMeeting(context);
      print('printing doc ID= $docId');
      if (docId != null) {
        final meetingData = await _firestore
            .collection('meetings')
            .doc(Provider.of<UserDetails>(context, listen: false)
                .currentClassCode)
            .collection('meetingRecord')
            .doc(docId)
            .collection('record')
            .get();
        int i = 1;
        for (var data in meetingData.docs) {
          List<String> dataList = [
            data.data()['name'],
            data.data()['email'],
            data.data()['dateTime'],
            data.data()['action']
          ];
          print(dataList);
          excel.insertRow(dataList: dataList, index: i, name: filename);
          dataList.clear();
          i = i + 1;
        }
        File file = File(excel.saveFile(filename));
        String url = await uploadAttendanceReport(file);
        await _firestore
            .collection('meetings')
            .doc(Provider.of<UserDetails>(context, listen: false)
                .currentClassCode)
            .collection('meetingRecord')
            .doc(docId)
            .update({'live': 'false', 'fileUrl': url});
        print(url);
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> uploadAttendanceReport(File file) async {
    try {
      String uploadedFileUrl;
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('meetingReports/${Path.basename(file.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(file);
      StorageTaskSnapshot cuyz = await uploadTask.onComplete;
      print('File Uploaded');
      uploadedFileUrl = await cuyz.ref.getDownloadURL();
      return uploadedFileUrl;
    } catch (e) {
      return null;
    }
  }

  Future<String> _getCurrentMeeting(context) async {
    final docid = await _firestore
        .collection('meetings')
        .doc(Provider.of<UserDetails>(context, listen: false).currentClassCode)
        .collection('meetingRecord')
        .where('live', isEqualTo: 'true')
        .get();
    String docId;
    for (var data in docid.docs) {
      docId = data.id;
    }
    return docId;
  }

  Future<bool> onJoinMeeting(context) async {
    //for student
    String docId = await _getCurrentMeeting(context);
    if (docId != null) {
      await _firestore
          .collection('meetings')
          .doc(
              Provider.of<UserDetails>(context, listen: false).currentClassCode)
          .collection('meetingRecord')
          .doc(docId)
          .collection('record')
          .doc()
          .set({
        'name': Provider.of<UserDetails>(context, listen: false).username,
        'email': Provider.of<UserDetails>(context, listen: false).Useremail,
        'dateTime': DateTime.now().toString(),
        'action': 'Joined'
      });
      return true;
    } else {
      return false;
    }
  }

  Future<void> onLeavingMeeting(context) async {
    //for student
    String docId = await _getCurrentMeeting(context);
    if (docId != null) {
      await _firestore
          .collection('meetings')
          .doc(
              Provider.of<UserDetails>(context, listen: false).currentClassCode)
          .collection('meetingRecord')
          .doc(docId)
          .collection('record')
          .doc()
          .set({
        'name': Provider.of<UserDetails>(context, listen: false).username,
        'email': Provider.of<UserDetails>(context, listen: false).Useremail,
        'dateTime': DateTime.now().toString(),
        'action': 'Left'
      });
    }
  }
}
