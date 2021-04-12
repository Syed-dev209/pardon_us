import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClassMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User loggedInUser;

  void getCurrentUser() async {
    try {
      final user = _auth
          .currentUser; //will return null if not logged in .Async method return future so await
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> createClass(
      {String title,
      String classCode,
      String imageUrl,
      String participantName,
      String email}) async {
    print(email);
    var userID;
    await firestore.collection('classes').doc(classCode).set({
      'classCode': classCode,
      'title': title,
      'teacher': participantName,
      'imageURL': imageUrl
    });
    firestore
        .collection('classes')
        .doc(classCode)
        .collection('participants')
        .doc()
        .set({'email': email, 'name': participantName, 'role': 'Teacher'});
    var user = await firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .get();
    for (var data in user.docs) {
      userID = data.id;
    }
    firestore
        .collection('user')
        .doc(userID)
        .collection('joinedClasses')
        .doc()
        .set({
      'classCode': classCode,
      'title': title,
      'teacher': participantName,
      'imageURL': imageUrl
    });
    return true;
  }

  Future<String> joinClass(
      {String classCode, String participantName, String email}) async {
    var userID;
    String cd, titl, tea, img, code, id;
    var classData = await firestore
        .collection('classes')
        .where('classCode', isEqualTo: classCode)
        .get(); //exist
    for (var data in classData.docs) {
      id = data.id;
    }
    if (id == null) {
      return 'not exist';
    } else {
      for (var data in classData.docs) {
        titl = data.data()['title'];
        tea = data.data()['teacher'];
        img = data.data()['imageURL'];
        code = data.data()['classCode'];
      }
      if (tea == participantName) {
        return 'Teacher';
      }
      getCurrentUser();
      firestore
          .collection('classes')
          .doc(classCode)
          .collection('participants')
          .doc()
          .set({
        'email': loggedInUser.email,
        'name': loggedInUser.displayName ?? 'user',
        'role': 'Student'
      });

      var user = await firestore
          .collection('user')
          .where('email', isEqualTo: loggedInUser.email)
          .get();
      for (var data in user.docs) {
        userID = data.id;
        if (classCode == data.data()['classCode']) {
          return 'Member';
        }
      }
      firestore
          .collection('user')
          .doc(userID)
          .collection('joinedClasses')
          .doc()
          .set({
        'classCode': classCode,
        'title': titl,
        'teacher': tea,
        'imageURL': img
      });
      return 'enter';
    }
  }

  Future<bool> exitClass(String classCode, String userEmail) async {
    var userID, classId;
    var user, clas;
    //Deleting class from user collection
    user = await firestore
        .collection('user')
        .where('email', isEqualTo: userEmail)
        .get();
    for (var data in user.docs) {
      userID = data.id;
    }
    clas = await firestore
        .collection('user')
        .doc(userID)
        .collection('joinedClasses')
        .where('classCode', isEqualTo: classCode)
        .get();
    for (var data in clas.docs) {
      classId = data.id;
    }
    firestore
        .collection('user')
        .doc(userID)
        .collection('joinedClasses')
        .doc(classId)
        .delete();
    //Deleting user from class collection
    user = await firestore
        .collection('classes')
        .doc(classCode)
        .collection('participants')
        .where('email', isEqualTo: userEmail)
        .get();
    for (var data in user.docs) {
      userID = data.id;
    }
    firestore
        .collection('classes')
        .doc(classCode)
        .collection('participants')
        .doc(userID)
        .delete();
    return true;
  }

  Future<bool> deleteClass(String classCode) async {
    //Delete class from users
    var participants = await firestore
        .collection('classes')
        .doc(classCode)
        .collection('participants')
        .get();
    for (var stdts in participants.docs) {
      exitClass(classCode, stdts.get('email'));
    }
    //Delete class from messages
    firestore.collection('messages').doc(classCode).delete();

    //Delete class from quiz
    firestore.collection('quizes').doc(classCode).delete();

    //Delete class from assignment
    firestore.collection('assignments').doc(classCode).delete();

    //Delete Class
    firestore.collection('classes').doc(classCode).delete();
    return true;
  }
}
