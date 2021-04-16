import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessengerMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uploadedImgUrl;
  String uploadedVideoUrl;

  void sendTextMsg(
      {String senderName,
      String classCode,
      String textMessage,
      String type = 'text'}) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    _firestore
        .collection('messages')
        .doc(classCode)
        .collection('classMessage')
        .doc()
        .set({
      'createdAt': time,
      'sender': senderName,
      'text': textMessage,
      'type': type
    });
  }

  void sendLink(
      {String senderName,
      String classCode,
      String link,
      String type = 'link'}) {
    sendTextMsg(
        senderName: senderName,
        classCode: classCode,
        textMessage: link,
        type: type);
  }

  void sendImage(File _image, String senderName, String classCode) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('messenger/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    StorageTaskSnapshot cuyz = await uploadTask.onComplete;
    print('File Uploaded');
    uploadedImgUrl = await cuyz.ref.getDownloadURL();
    print('Image URl :- $uploadedImgUrl');
    sendTextMsg(
        senderName: senderName,
        classCode: classCode,
        textMessage: uploadedImgUrl,
        type: 'image');
  }

  Future<File> chooseVideo() async {
    final picker = ImagePicker();
    PlatformFile pickedFile;
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final imagePicker = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp4']);
    if (imagePicker != null) {
      pickedFile = imagePicker.files.first;
    }
    return File(pickedFile.path);
  }

  Future<bool> sendVideo(
      File _video, String senderName, String classCode) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('messengerVideos/${Path.basename(_video.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_video);
    StorageTaskSnapshot cuyz = await uploadTask.onComplete;
    print('File Uploaded');
    uploadedVideoUrl = await cuyz.ref.getDownloadURL();
    print('Video URl :- $uploadedVideoUrl');
    sendTextMsg(
        senderName: senderName,
        classCode: classCode,
        textMessage: uploadedVideoUrl,
        type: 'video');
    return true;
  }
}
