import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';


class FilesUpload{
  FirebaseFirestore firestore= FirebaseFirestore.instance;

 Future<bool> uploadQuizDetails(String quizTitle,String time,String date,String fileUrl,String classCode)async{
   firestore.collection('quizes').doc(classCode).collection('quiz').doc().set({
     'title':quizTitle,
     'date':date.toString(),
     'time':time,
     'imageUrl':fileUrl,
     'type':'file'
   });
   return true;
 }
  Future<bool> uploadAssignmentDetails(String assignmentTitle,String time,String date,String fileUrl,String classCode)async{
    firestore.collection('assignments').doc(classCode).collection('assignment').doc().set({
      'title':assignmentTitle,
      'date':date.toString(),
      'time':time,
      'imageUrl':fileUrl,
      'type':'file'
    });
    return true;
  }
Future<bool> submitStudentAssignment({String name,PlatformFile assFile,String classCode,String assDocId})async
{
  try {
    String fileUrl = await uploadFile(assFile, classCode, 'assignmentFiles');
    await firestore.collection('assignments').doc(classCode).collection(
        'assignment').doc(assDocId).collection('attemptedBy').doc().set({
      'name': name,
      'dateTime': DateTime.now().toString(),
      'fileUrl': fileUrl,
      'marksObtained': '0'
    });
    return true;
  }
  catch(e){
    return false;
  }

}

Future<bool> gradeStudentAssignment({String classCode,String marks,String assDocId,String stdDocId})async{
   try{
     await firestore.collection('assignments').doc(classCode).collection('assignment').doc(assDocId).collection('attemptedBy').doc(stdDocId).update({
       'marksObtained':marks
     });
     return true;
   }
   catch(e){
     return false;
   }
}

  Future<String> uploadFile(PlatformFile _file,String classCode,String ref) async {
  // File ccc= _file as File;
    String uploadedFileUrl;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('$ref/${_file.name}');
    StorageUploadTask uploadTask = storageReference.putFile(File(_file.path));
    StorageTaskSnapshot cuyz= await uploadTask.onComplete;
    print('File Uploaded');
    uploadedFileUrl= await cuyz.ref.getDownloadURL();
    print('File URl :- $uploadedFileUrl');

    return uploadedFileUrl;

  }
}