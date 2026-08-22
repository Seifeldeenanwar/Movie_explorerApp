import 'dart:convert';
import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? nameValidation(String? name) {
    if (name == null || name.trim().isEmpty) {
      return "Field is empty!";
    }
    if (name.trim().length <= 3) {
      return "Must enter above 3 characters";
    }
    return null;
  }

  String? emailValidation(String? email) {
    if (email == null || email.trim().isEmpty) {
      return "Field is empty!";
    }
    final RegExp emailPattern = RegExp(r"^[\w_.-]+@[\w_.-]+\.[a-zA-Z]{2,}$");
    if (!emailPattern.hasMatch(email.trim())) {
      return "Invalid email format!";
    }
    return null;
  }

  String? passwordValidation(String? password) {
    if (password == null || password.trim().isEmpty) {
      return "Field is empty!";
    }
    final RegExp passwordPattern = RegExp(r"^[A-Za-z\d@$!%*#?&_\-]{6,20}$");
    if (!passwordPattern.hasMatch(password)) {
      return "Make a stronger password (6-20 characters)!";
    }
    return null;
  }

  String? confirmPasswordValidation(String? password) {
    if (password == null || password.trim().isEmpty) {
      return "Field is empty!";
    }
    if (password != _passwordController.text) {
      return "Passwords do not match!";
    }
    return null;
  }

  InputDecoration _inputDecoration({
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    final pref = await SharedPreferences.getInstance();
    String prevUsers = pref.getString("users") ?? "";

    List<Map<String, dynamic>> decodedUsers = [];
    if (prevUsers.isNotEmpty) {
      List<dynamic> rawList = jsonDecode(prevUsers);
      decodedUsers = rawList.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    decodedUsers.add({
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    });

    await pref.setString("users", jsonEncode(decodedUsers));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp", style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: "Name",
                  hint: "Please enter your name",
                  icon: Icons.person,
                ),
                validator: nameValidation,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: "Email",
                  hint: "Please enter your email",
                  icon: Icons.email,
                ),
                validator: emailValidation,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: "Password",
                  hint: "Please enter your password",
                  icon: Icons.lock,
                ),
                validator: passwordValidation,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration(
                  label: "Confirm Password",
                  hint: "Please confirm your password",
                  icon: Icons.lock_reset_sharp,
                ),
                validator: confirmPasswordValidation,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create new account", style: TextStyle(fontSize: 16)),
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
    );
  }
}