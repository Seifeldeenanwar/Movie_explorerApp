import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  //List<Map<String,dynamic>> user = [] ;
  int currentUser = 0 ;
  // void adduser({String name = "no name" , String email = "no email" ,String password = "not set"}){
  //   user.add({"name":name , "email" :email , "password" :password }) ;
  //   notifyListeners() ;
  // }
  // Map<String,dynamic> getuser({ required String email  ,required String password}){
  //   for(int i = 0 ; i < user.length ; i++){
  //     if(user[i]["email"] == email && user[i]["password"] == password){
  //       return user[i] ; 
  //     }
  //   }
  //   return {} ;
  // }
  void changeCurrentUser(int i){
    currentUser = i ;
    notifyListeners() ;
  }
  
}