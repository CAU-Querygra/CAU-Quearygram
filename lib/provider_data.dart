import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData with ChangeNotifier{
  User? user;
  String id ="BuVJIFMHMmaKDBzA08CIVSMb3Wy2";
  String user_name = "홍길동";
  String email = "cau@cau.ac.kr";

  set_user_data(user, id, user_name, email){
    this.user = user;
    this.id = id;
    this.user_name = user_name;
    this.email=email;
    notifyListeners();
  }

}

class LectureData with ChangeNotifier{
  String lecture_id = '';
  String question_id = 'rrfAI0l62W2AqAcBUPn6';

  set_lecture_id(lecture_id){
    this.lecture_id=lecture_id;
    notifyListeners();
  }

  set_question_id(question_id){
    this.question_id = question_id;
    notifyListeners();
  }

}
