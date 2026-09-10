import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lab_2/functions.dart';
import 'package:lab_2/pages/forgotPassword.dart';
import 'package:lab_2/pages/home_page.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:lab_2/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key}) ;
  @override
  State<LoginPage> createState()=> LoginState() ;
}
class LoginState extends State<LoginPage> {
  // GlobalKey<FormState>_formKey = GlobalKey<FormState>()  ;

  late TextEditingController _emailController ;
  late TextEditingController _passwordController ;
  final FirebaseAuth auth = FirebaseAuth.instance;
  //final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  // Future<void> initializeGoogleSignIn() async {
  //   await googleSignIn.initialize();
  // }

  @override
  void initState() {
    super.initState();
    //initializeGoogleSignIn();
    // _formKey = GlobalKey<FormState>()  ;
    _passwordController = TextEditingController();
    _emailController = TextEditingController() ;
  }
  @override
  void dispose(){
    super.dispose() ;
    _passwordController.dispose() ;
    _emailController.dispose() ;
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future signInWithGoogle() async {
    try {
      final GoogleAuthProvider provider = GoogleAuthProvider();
      final UserCredential credential = await auth.signInWithPopup(provider);
      final User? user = credential.user;
      if (user == null) {
        showMessage("Google sign in failed");
        return;
      }
      if (!mounted) return;
      final userData = context.read<UsersData>();
      userData.addUserData(user.displayName ?? "Google User", user.email ?? "Unknown", false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      showMessage("error: ${e.message ?? e.code}");
    } catch (e) {
      showMessage("Google sign in failed: $e");
    }
  }
  Future<void> _submitForm() async {

    // final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    // if (!_formKey.currentState!.validate()) return ;
    // if (context.mounted) {
    //   final prefs = await SharedPreferences.getInstance() ;
    //   String users = prefs.getString("users") ?? "" ;
    //   if(users.isEmpty){
    //     setState(() {
    //       checkUserLogin = false ;
    //     });
    //       return ;
    //   }
    //   List<dynamic> decodedUsersDynamic = jsonDecode(users) ;
    //   List<Map<String,dynamic>>  decodedUsers = decodedUsersDynamic.map((e)=>Map<String,dynamic>.from(e)).toList() ;
    //   for(int i = 0 ; i < decodedUsers.length ; i++){
    //     if(decodedUsers[i]["password"] == _passwordController.text && decodedUsers[i]["email"] == _emailController.text){
    //       profileProvider.changeCurrentUser(i) ;
    //       print(prefs.getString("users")) ;
    //       Navigator.pushReplacementNamed(context, "/home");

    //     }
    //   }
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
      //}
      String email = _emailController.text.trim() ;
      String password = _passwordController.text.trim() ;
      String? checkEmail = emailValiation(email) ;
      String? checkPass = passwordValidation(password) ;
      if(checkEmail != null){
        showMessage(checkEmail) ;
        return ;
      }
      if(checkPass != null){
        showMessage(checkPass) ;
        return ;
      }
      try{
        final UserCredential credential = await auth.signInWithEmailAndPassword(email: email,password: password) ;
        final User? user = credential.user ;
        if(user == null){
          showMessage("User doesn't exists") ;
          return ;
        }
        if(!user.emailVerified){
          await auth.signOut() ;
          showMessage("Email not verfied") ;
          return ;
        } 
        if(!mounted)return ;
        Future.delayed(Duration(seconds: 1)) ;
        Navigator.pushReplacementNamed(context, "/home") ;
      }
      on FirebaseAuthException catch(e){
        String mess ;
        switch(e.code){
        case 'invalid-email':
          mess = "invalid email!" ;
          break;
        case 'operation-not-allowed':
          mess = "Authentication not enabled" ;      
          break;
        case 'user-not-found':
          mess = "Account doesn't exist with this email";
          break;
        case 'wrong-password':
          mess = "Incorrect passowrd";
          break;
        case 'too-many-requests':
          mess = "too many attempts to login" ;    
          break ; 
        default:
          mess = "There is error exists, check credentials" ;  
        }
        showMessage(mess) ;
      }
      catch(e){
        showMessage("There is error exists, check credentials") ;
      }
    }
  
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Login Page"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: 
    SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Form(
            //key: _formKey,
            child: 
            Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration(label: "email", hint: "please enter your email", icon: Icons.email),
                  // validator: emailValiation,
                             
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: inputDecoration(label: "password", hint: "please enter your password", icon: Icons.lock),
                  // validator: passwordValiation,
                             
                ),
                    Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                    }, child: Text("Forgot password?"))
                  ),
                SizedBox(height: 5,),
                ElevatedButton(
                  onPressed: () { 
                    _submitForm();
                  },
                  child: Text("Login",style: TextStyle(fontSize: 16)),
                ),
                  SizedBox(height: 5,) ,
                SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.g_mobiledata , size : 30) ,
                      onPressed: signInWithGoogle,
                      label: Text("Signin with Google",style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, "/signup") ;
                
                  }, child: Text("create new account",),),
                        
          ]
          )),
        )),
    )) ;
  }

}
