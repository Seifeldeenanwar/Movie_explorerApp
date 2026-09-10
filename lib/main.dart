import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/firebase_options.dart';
import 'package:lab_2/pages/admin_view.dart';
import 'package:lab_2/pages/alternative_movie_list.dart';
import 'package:lab_2/pages/genres_page.dart';
import 'package:lab_2/pages/home_page.dart';
import 'package:lab_2/pages/login_page.dart';
import 'package:lab_2/pages/movie_page.dart';
import 'package:lab_2/pages/profile.dart';
import 'package:lab_2/pages/signup_page.dart';
import 'package:lab_2/providers/admin_provider.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:lab_2/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main()async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName:'.env') ;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>FavoriteProvider()),
      ChangeNotifierProvider(create:(context)=> ProfileProvider()),
      ChangeNotifierProvider(create:(context)=> UsersData()),
      ChangeNotifierProvider(create:(context)=> AdminProvider()),
      ],
    child: 
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Movie Explorer Application',
      initialRoute: "/signup",
      routes: {
        "/login" : (context) => LoginPage() ,
        "/home" :  (context) => HomePage() ,
        "/movie" :  (context) => MoviePage() ,
        "/genres" :  (context) => GenresPage() ,
        // "/separated" : (context) =>AlternativeMovieList() ,
        "/signup" : (context) => SignupPage() ,
        "/profile": (context) =>Profile() ,
        "/admin" : (context) => AdminView() ,
      },
    )
    );
  }
}

