import 'package:flutter/material.dart';

String? nameValidation(String? name) {
  if (name == null || name.trim().isEmpty) {
    return "Name field is empty!";
  }
  if (name.trim().length <= 3) {
    return "Name field must be above 3 characters";
  }
  return null;
}

String? passwordValidation(String? password){
  if(password == null || password.trim().isEmpty){
    return "Password field is empty!" ;
  }
  final RegExp passwordPattern = RegExp(r"^[A-Za-z\d@$!%*#?&_\-]{6,20}$");
  if(!passwordPattern.hasMatch(password)){
    return "make stronger password!" ;
  }  
  return null ;
}

String? emailValiation(String? email){
  if(email == null || email.trim().isEmpty){
    return "Email field is empty!" ;
  }
  final RegExp emailPattern = RegExp(r"^[\w_.-]{3,}@[\w_.-]{3,5}\.[a-zA-Z]{2,3}$") ;
  if(!emailPattern.hasMatch(email)){
    return "Invalid email format!" ;
  }  
  return null ;
}

String getFirstTwoLetters(String? text){
  if(text == null || text.trim().isEmpty){
    return "" ;
  }
  List<String> l = text.trim().split(" ") ;
  int len = l.length ;
  if(len > 1){
    String res = "${l.first[0]}${l.last[0]}";
    return res.toUpperCase() ;
}

String singleWord = l.first;
  if (singleWord.length < 2) {
    return singleWord.toUpperCase();
  }
  return singleWord.substring(0,2).toUpperCase() ;  
}

  InputDecoration inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 135, 67, 162)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 2),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

