import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/functions.dart';
class ForgotPasswordPage extends StatefulWidget{
  ForgotPasswordPage({super.key}) ;
  @override
  State<ForgotPasswordPage> createState()=>ForgotState() ;
}

class ForgotState extends State<ForgotPasswordPage>{
  late TextEditingController _emailController ;
  final FirebaseAuth auth = FirebaseAuth.instance ;

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController() ;
  }
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future<void> resetPassword() async{
    String email = _emailController.text.trim() ;
    String? checkEmail = emailValiation(email) ;
    if(checkEmail != null){
      showMessage(checkEmail) ;
      return ;
    }
    try{
      await auth.sendPasswordResetEmail(email: email) ;
      showMessage("passord reset email sent successfullly") ;
      await Future.delayed(Duration(seconds: 1)) ;
      if (!mounted) return;
      Navigator.pop(context);
    }
    on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "email address is not valid";
          break;
        case 'user-not-found':
          message = "Account doesn't exist with this email";
          break;
        case 'too-many-requests':
          message = "Too many login attempts, try again after 1 min";
          break;
        case 'operation-not-allowed':
          message = "Email/Password Authentication is not enabled";
          break;
        default:
          message = e.message ?? "something went wrong";
      }
      showMessage(message);
    } catch (e) {
      showMessage("something went wrong");
    }



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot password"),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Icon(Icons.lock_reset_sharp,size: 30,) ,
            SizedBox(height: 15,),
            Align(alignment: Alignment.centerLeft,child: Text("Enter your Email :")) ,
            SizedBox(height: 10,),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(label: Text("Email"),hint: Text("Enter your email for reset password"),border: OutlineInputBorder()),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: resetPassword, child: Text("Submit"))
            
          ],
        ),
      ),
    );
  }
}