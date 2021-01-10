import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class LogInMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);
  bool isLoggedIn = false;
  final firestore = FirebaseFirestore.instance;
  String uploadedImgUrl;


  Future<String> loginGoogle()async{
    googleSignOut();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gsa= await googleSignInAccount.authentication;
    AuthCredential credentials= GoogleAuthProvider.credential(idToken: gsa.idToken,accessToken: gsa.accessToken);
    try{
    final userCheck = firestore.collection('user').where('email',isEqualTo: googleSignInAccount.email).get();
    user = (await _auth.signInWithCredential(credentials)).user;
    firestore.collection('user').add({
      'email':user.email,
      'name':user.displayName,
      'profile':user.photoURL
    });
    return 'created';
    }
    catch(e){
      return 'user exist';
    }

  }
  Future<String> signinGoogle()async{
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gsa= await googleSignInAccount.authentication;
    AuthCredential credentials= GoogleAuthProvider.credential(idToken: gsa.idToken,accessToken: gsa.accessToken);
    try {
      final userCheck = firestore.collection('user').where(
          'email', isEqualTo: googleSignInAccount.email).get();
      user = (await _auth.signInWithCredential(credentials)).user;
      return user.email;
    }
    catch(e){
      return 'false';
    }
  }


  Future<bool> googleSignOut() async {
    await _auth.signOut().then((value) {
      googleSignIn.signOut();
      isLoggedIn = false;
    });
    return isLoggedIn;
  }


  Future<File> chooseProfileImage()async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }


  Future<String> uploadProfileImage(File _image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    StorageTaskSnapshot cuyz= await uploadTask.onComplete;
    print('File Uploaded');
    uploadedImgUrl= await cuyz.ref.getDownloadURL();
    print('Image URl :- $uploadedImgUrl');
    return uploadedImgUrl;

  }

  Future<String> registerUser(String email, String password, String name ,File img) async
  {
    final userCheck = await firestore.collection('user').where('email',isEqualTo: email).get();
    if(userCheck==null){
      return 'user exist';
    }
    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    String imageUrl=await uploadProfileImage(img);
    if(imageUrl==null)
      {
        imageUrl='http://www.pngall.com/wp-content/uploads/5/User-Profile-Transparent.png';
      }
    firestore.collection('user').add({
      'email':email,
      'name':name,
      'profile':imageUrl
    });
    return 'created';
  }

  Future<bool> logInUser(String email,String password)async{
    user =(await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
    )).user;
    if(user!=null){
      return true;
    }
    else{
      return false;
    }
  }


}
