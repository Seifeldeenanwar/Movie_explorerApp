import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab_2/pages/favorite.dart';
import 'package:lab_2/pages/genres_page.dart';
import 'package:lab_2/pages/movie_page.dart';
import 'package:lab_2/pages/profile.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget{
  int selectedIndex ;
  HomePage({super.key,this.selectedIndex = 0});
  
  @override
  State<HomePage> createState() => HomeState() ;
}

class HomeState extends State<HomePage>{
  late List<Widget> widgets ;
  @override
  void initState(){
    super.initState();
    // print("home init") ;
    widgets = [
    MoviePage() ,
    FavoritePage() ,
    GenresPage() ,
    Profile()
  ] ;
  
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
  Future<List<Map<String,dynamic>>> getusers() async{
    final prefs = await SharedPreferences.getInstance() ;
    String usersInString = prefs.getString("users") ?? "" ;
    if(usersInString.isEmpty){
      return [] ;
    }
    List<dynamic> decodedUsers = jsonDecode(usersInString) ;
    return decodedUsers.map((e)=>Map<String,dynamic>.from(e)).toList() ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Consumer<ProfileProvider>(builder: (context,profileModel,child){
              return 
            FutureBuilder(
              future: getusers(),
              builder: (context, asyncSnapshot) {
                if(asyncSnapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),) ;
                }
                List users = asyncSnapshot.data ?? [] ;
                if(users.isEmpty || profileModel.currentUser > users.length){
                  return UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(),
                  accountName: Text("no name") , accountEmail: Text("no email"));
                }
                return UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(child: Text(getFirstTwoLetters(users[profileModel.currentUser]["name"])),),
                  accountName: Text(users[profileModel.currentUser]["name"]) , accountEmail: Text(users[profileModel.currentUser]["email"]));
              }
            );
            }),
            ListTile(title: Text("Movies"),
            leading: Icon(Icons.movie),
            onTap: (){
              Navigator.pop(context);
              setState(() {
                widget.selectedIndex = 0 ;
              });
            },),
            ListTile(title: Text("Profile"),
            leading: Icon(Icons.person),
            onTap: (){
              Navigator.pop(context) ;
              setState(() {
                widget.selectedIndex = 3 ;
              });
            },),
            ListTile(title: Text("Favorite"),
            leading: Icon(Icons.favorite),
            onTap: (){
              Navigator.pop(context) ;
              setState(() {
                widget.selectedIndex = 1 ;
              });
            },),
            Consumer<FavoriteProvider>(
              builder: (context ,favModel,child){
                return 
                  ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.logout),
                  onTap: (){
                    Navigator.pushNamedAndRemoveUntil(context, "/login", (context)=>false) ;
                    
                    favModel.clearFav() ;
                  },
                );
            },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: widget.selectedIndex ,
        onTap: (val){
          setState(() {  
            widget.selectedIndex = val ;
          });
        },
        unselectedItemColor: const Color.fromARGB(255, 167, 118, 186),
        selectedItemColor:const Color.fromARGB(255, 135, 67, 162) ,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie) ,label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.category),label: "Genres"),
          BottomNavigationBarItem(icon: Icon(Icons.person,),label: "Profile",),
      ]),
      appBar: AppBar(
        title: Text("Movie Explorer"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body:  IndexedStack(
            index: widget.selectedIndex,
            children: widgets,
          ), 
    ) ;
  }
}