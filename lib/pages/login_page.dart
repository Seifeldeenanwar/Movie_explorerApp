import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  LoginPage({super.key}) ;
  @override
  State<LoginPage> createState()=> LoginState() ;
}
class LoginState extends State<LoginPage> {
  late TextEditingController _emailController ;
  late TextEditingController _passwordController ;
  GlobalKey<FormState>_formKey = GlobalKey<FormState>()  ;
  bool checkUserLogin = true ;
    @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>()  ;
    _passwordController = TextEditingController();
    _emailController = TextEditingController() ;
  }
  @override
  void dispose(){
    super.dispose() ;
    _passwordController.dispose() ;
    _emailController.dispose() ;
  }

  String? passwordValiation(String? password){
    if(password == null || password.trim().isEmpty){
      return "Field is empty!" ;
    }
    final RegExp passwordPattern = RegExp(r"^[A-Za-z\d@$!%*#?&_\-]{6,20}$");
    if(!passwordPattern.hasMatch(password)){
      return "make stronger password!" ;
    }  
    return null ;
  }
  String? emailValiation(String? email){
    if(email == null || email.trim().isEmpty){
      return "Field is empty!" ;
    }
    final RegExp emailPattern = RegExp(r"^[\w_.-]{3,}@[\w_.-]{3,5}.[a-zA-Z]{2,3}$") ;
    if(!emailPattern.hasMatch(email)){
      return "Invalid email format!" ;
    }  
    return null ;
  }

  InputDecoration _inputDecoration({required String label,required String hint,required IconData icon,}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon,color: const Color.fromARGB(255, 135, 67, 162),),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(width: 2),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }
  Future<void> _submitForm() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) return ;
    if (context.mounted) {
      final prefs = await SharedPreferences.getInstance() ;
      String users = prefs.getString("users") ?? "" ;
      if(users.isEmpty){
        setState(() {
          checkUserLogin = false ;
        });
          return ;
      }
      List<dynamic> decodedUsersDynamic = jsonDecode(users) ;
      List<Map<String,dynamic>>  decodedUsers = decodedUsersDynamic.map((e)=>Map<String,dynamic>.from(e)).toList() ;
      for(int i = 0 ; i < decodedUsers.length ; i++){
        if(decodedUsers[i]["password"] == _passwordController.text && decodedUsers[i]["email"] == _emailController.text){
          profileProvider.changeCurrentUser(i) ;
          print(prefs.getString("users")) ;
          Navigator.pushReplacementNamed(context, "/home");

        }
      }
      // for(int i = 0 ; i < profileProvider.user.length ; i++ ){
      //   if(profileProvider.user[i]["password"] == _passwordController.text && profileProvider.user[i]["email"] == _emailController.text){
      //     final pref = await SharedPreferences.getInstance();
      //     List<String> currentList = pref.getStringList("dateTime") ?? [];
      //     currentList.add(DateTime.now().toIso8601String());
      //     if (currentList.length > 20) {
      //       currentList = currentList.sublist(currentList.length - 20);
      //     }
      //     await pref.setStringList("dateTime", currentList);      
      //     print(pref.getStringList("dateTime")) ;    
      //     profileProvider.currentUser = i ;
      //     Navigator.pushReplacementNamed(context, "/home");
      //   }
      }
      setState(() {
        checkUserLogin = false ;
      });
    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Login Page"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: 
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: 
      Form(
        key: _formKey,
        child: 
        Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(label: "email", hint: "please enter your email", icon: Icons.email),
              validator: emailValiation,
                         
            ),
            SizedBox(height: 8,),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: _inputDecoration(label: "password", hint: "please enter your password", icon: Icons.lock),
              validator: passwordValiation,
                         
            ),
            SizedBox(height: 10,),
            SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () { 
                    _submitForm();
                  },
                  child: Text("Login",style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, "/signup") ;
            
              }, child: Text("create new account",),),
              SizedBox(height: 20,),
              checkUserLogin == false ? Text("Incorrect credientials!",style: TextStyle(color: Colors.red),):Text(""),
      
      ]
      )))) ;
  }

}
