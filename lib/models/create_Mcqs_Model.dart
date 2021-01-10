import 'package:flutter/material.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class QuizModel extends ChangeNotifier{
  FirebaseFirestore firestore= FirebaseFirestore.instance;
  Map<String,String> quizDeatils;
  List<String> questions=[];
  List<String> corrAns=[];
  List<String> opt1=[];
  List<String> opt2=[];
  List<String> opt3=[];
  List<String> marks=[];
  List<String> selectedAns=[];
  String classCode;
  int stepCount;
  Map<int,String> sAns={
    0:''
  };

  addQuizDetails(String QuizTitle,String time,String date,String ImageUrl){
    quizDeatils={
      'title':QuizTitle,
      'date':date,
      'time':time,
      'imageUrl':ImageUrl,
      'type':'mcqs'
    };
    print(quizDeatils);
    notifyListeners();
  }

  addQuestion(String question){
    questions.add(question);
    notifyListeners();
  }

  addOptions({String one,String two,String three}){
    opt1.add(one);
    opt2.add(two);
    opt3.add(three);
    notifyListeners();
  }
  addCorrectAnswer(String correct){
    corrAns.add(correct);
  }
  addPoints(String points){
    marks.add(points);
    notifyListeners();
  }

  bool addQuizQuestions({String question,String one,String two,String three,String correct,String points}){
    print(correct+','+one+','+two+','+three);
    if(correct==one||correct==two||correct==three)
    {
      addQuestion(question);
      addPoints(points);
      addOptions(one: one, two: two, three: three);
      addCorrectAnswer(correct);
      return true;
    }
    else {
        return false;
    }
  }

  printAll(){
    print(quizDeatils);
    print(questions);
    print(corrAns);
    print(opt1);
    print(opt2);
    print(opt3);
    print(marks);
  }

  Future<String> submitQuiz(String classcode)async{
    classCode=classcode;
    if(questions.isEmpty||corrAns.isEmpty){
      return 'empty';
    }
    else {
      DocumentReference docRef = firestore.collection('quizes')
          .doc(classCode)
          .collection('quiz')
          .doc();
      docRef.set(quizDeatils);

      for (int i = 0; i < questions.length; i++) {
        submitQuestions(
            questions[i],
            corrAns[i],
            opt1[i],
            opt2[i],
            opt3[i],
            marks[i],
            docRef.id);
      }
      return 'submitted';
    }
  }

   submitQuestions(String ques,String ans,String op1,String op2,String op3,String point,String docId)async{

      firestore.collection('quizes').doc(classCode).collection(
          'quiz').doc(docId).collection('questions')
          .doc()
          .set({
        'question': ques,
        'corrAns': ans,
        'opt1': op1,
        'opt2': op2,
        'op3': op3,
        'points': point
      });

  }

  Future<bool> submitStudentMcqResult(context,int marksObtained,String docId)async{
   DocumentReference docRef= firestore.collection('quizes').doc(Provider.of<UserDetails>(context,listen: false).currentClassCode).collection('quiz').doc(docId).collection('attemptedBy').doc();
   docRef.set(
     {
       'name':Provider.of<UserDetails>(context,listen: false).username,
       'dateTime':DateTime.now().toString(),
       'marksObtained':marksObtained,
     }
   );
   sAns.forEach((key, value) {
     docRef.update({'ans${key.toString()}':value});
   });
   return true;
  }

  Future<bool> submitStudentQuizFile(context,String fileUrl,String docId)async{
    DocumentReference docRef=firestore.collection('quizes').doc(Provider.of<UserDetails>(context,listen: false).currentClassCode).collection('quiz').doc(docId).collection('attemptedBy').doc();
    docRef.set({
      'name':Provider.of<UserDetails>(context,listen: false).username,
      'dateTime':DateTime.now().toString(),
      'marksObtained':'0',
      'fileUrl':fileUrl
    });
    return true;
  }

  clearLists(){
    questions.clear();
    corrAns.clear();
    opt1.clear();
    opt2.clear();
    opt3.clear();
    marks.clear();
  }

  setStepCount(int num)
  {
    stepCount=num;
    notifyListeners();
  }
  setCorrAns(String ans){
    corrAns.add(ans);
    notifyListeners();
  }
  setSelAns(String ans,int i){
    print(ans);
    try{
      sAns[i]=ans;
      print(sAns);
    }
    catch(e) {
      sAns.putIfAbsent(i, () => ans);
      print(sAns);
    }
    notifyListeners();
  }

  int checkAnswers(){
    int result=0;
    final ans=corrAns.asMap();
    final check=selectedAns.asMap();
    print(corrAns);
    print(sAns);
    print('=============');
    print(ans);
    print(check);
    for(int i=0;i<corrAns.length;i++){
      if(ans[i]==sAns[i]){
        result++;
      }
    }
    return result;
  }
  int get getStepCount{
    return stepCount;
  }


}