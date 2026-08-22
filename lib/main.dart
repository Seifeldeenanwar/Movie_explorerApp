import 'package:flutter/material.dart';
import 'package:lab_2/pages/alternative_movie_list.dart';
import 'package:lab_2/pages/genres_page.dart';
import 'package:lab_2/pages/home_page.dart';
import 'package:lab_2/pages/login_page.dart';
import 'package:lab_2/pages/movie_page.dart';
import 'package:lab_2/pages/profile.dart';
import 'package:lab_2/pages/signup_page.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return 
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>FavoriteProvider()),
      ChangeNotifierProvider(create:(context)=> ProfileProvider())
      ],
    child: 
    MaterialApp(
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
        "/profile": (context) =>Profile() 
      },
    )
    );
  }
}

