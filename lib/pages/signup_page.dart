import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/functions.dart';
import 'package:lab_2/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => SignUpState();
}

class SignUpState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // bool _isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance ;
  bool admin = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String? confirmPasswordValidation(String? password) {
    if (password == null || password.trim().isEmpty) {
      return "Confirmation field is empty!";
    }
    if (password != _passwordController.text) {
      return "Passwords do not match!";
    }
    return null;
  }


  Future<void> _submitForm() async {
    // if (!_formKey.currentState!.validate()) return;

    // setState(() {
    //   _isLoading = true;
    // });

    // await Future.delayed(const Duration(seconds: 2));
    // final pref = await SharedPreferences.getInstance();
    // String prevUsers = pref.getString("users") ?? "";

    // List<Map<String, dynamic>> decodedUsers = [];
    // if (prevUsers.isNotEmpty) {
    //   List<dynamic> rawList = jsonDecode(prevUsers);
    //   decodedUsers = rawList.map((e) => Map<String, dynamic>.from(e)).toList();
    // }
    // decodedUsers.add({
    //   "name": _nameController.text.trim(),
    //   "email": _emailController.text.trim(),
    //   "password": _passwordController.text,
    // });

    // await pref.setString("users", jsonEncode(decodedUsers));
    // if (!mounted) return;

    // setState(() {
    //   _isLoading = false;
    // });
    String name = _nameController.text.trim() ;
    String email = _emailController.text.trim() ;
    String password = _passwordController.text.trim() ;
    String confirmPassword = _confirmPasswordController.text.trim() ;
    String? checkName = nameValidation(name) ;
    if(checkName != null){
      showMessage(checkName) ;
      return ;
    } 
    String? checkEmail = emailValiation(email) ;
    if(checkEmail != null){
      showMessage(checkEmail) ;
      return ;
    } 
    String? checkPass = passwordValidation(password) ;
    if(checkPass != null){
      showMessage(checkPass) ;
      return ;
    } 
    String? checkConfirmation = confirmPasswordValidation(confirmPassword) ;
    if(checkConfirmation != null){
      showMessage(checkConfirmation) ;
      return ;
    } 
    try{
      final UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password) ;
      final User? user = credential.user ;
      if(user != null){
        user.updateDisplayName(name) ;
      }
      if(user != null && !user.emailVerified){
        user.sendEmailVerification() ;
        showMessage("Signup successfully ,check you Gmail") ;
        await Future.delayed(Duration(seconds: 1)) ;
        if(!mounted) return ;
        final user_data = context.read<UsersData>() ;
        user_data.addUserData(name, email, false) ;
        Navigator.pushReplacementNamed(context, "/login");
      }
    }
    on FirebaseAuthException catch(e){
      String mess ;
      switch(e.code){
        case "invalid-email":
          mess = "invalid email!" ;
          break;
        case "email_already_in_use":
          mess = "email already exists" ;
          break;
        case "weak-password":
          mess = "your input password is weak" ;
          break;
        case "operation-not-allowed":
          mess = "Authentication not enabled" ;      
          break;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp", style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: 
      Container(
        margin: const EdgeInsets.all(16.0),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: 
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration(
                    label: "Name",
                    hint: "Please enter your name",
                    icon: Icons.person,
                  ),
                  // validator: nameValidation,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration(
                    label: "Email",
                    hint: "Please enter your email",
                    icon: Icons.email,
                  ),
                  // validator: emailValidation,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration(
                    label: "Password",
                    hint: "Please enter your password",
                    icon: Icons.lock,
                  ),
                  // validator: passwordValidation,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: inputDecoration(
                    label: "Confirm Password",
                    hint: "Please confirm your password",
                    icon: Icons.lock_reset_sharp,
                  ),
                  // validator: confirmPasswordValidation,
                ),
                // SizedBox(height: 10),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: 
                        const Text("Create new account", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height:10) ,
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, "/login") ;
                }, child: Text("I already have an account"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}