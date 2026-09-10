import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/functions.dart';
import 'package:lab_2/pages/favorite.dart';
import 'package:lab_2/pages/generated_movie_list.dart';
import 'package:lab_2/pages/genres_page.dart';
import 'package:lab_2/pages/movie_page.dart';
import 'package:lab_2/pages/profile.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:lab_2/providers/user_data.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance ;
  bool isAdmin = false ;

Future<void> checkAdmin() async {
  final userProvider = context.read<UsersData>();
  final admin = await userProvider.getIsAdmin();
  if (!mounted) return;
  setState(() {
    isAdmin = admin;
  });
}

  @override
  void initState(){
    super.initState();
    // print("home init") ;
    widgets = [
    MoviePage() ,
    GeneratedMovieList() ,
    FavoritePage() ,
    Profile()
  ] ;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    checkAdmin();
  });

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
            // Consumer<ProfileProvider>(builder: (context,profileModel,child){
            //   return 
            // FutureBuilder(
            //   future: getusers(),
            //   builder: (context, asyncSnapshot) {
            //     if(asyncSnapshot.connectionState == ConnectionState.waiting){
            //       return Center(child: CircularProgressIndicator(),) ;
            //     }
            //     List users = asyncSnapshot.data ?? [] ;
            //     if(users.isEmpty || profileModel.currentUser > users.length){
            //       return UserAccountsDrawerHeader(
            //       currentAccountPicture: CircleAvatar(),
            //       accountName: Text("no name") , accountEmail: Text("no email"));
            //     }
            //     return 
            // UserAccountsDrawerHeader(
            //       currentAccountPicture: CircleAvatar(child: Text(getFirstTwoLetters(users[profileModel.currentUser]["name"])),),
            //       accountName: Text(users[profileModel.currentUser]["name"]) , accountEmail: Text(users[profileModel.currentUser]["email"]));
            //   }
            // );
            // }),
            UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(child: Text(getFirstTwoLetters(auth.currentUser!.displayName)),),
            accountName: Text("${auth.currentUser!.displayName}") , accountEmail: Text("${auth.currentUser!.email}")),
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
                widget.selectedIndex = 2 ;
              });
            },),
            if(isAdmin)
            ListTile(title: Text("Admin access"),
            leading: Icon(Icons.admin_panel_settings),
            onTap: (){
              Navigator.pop(context) ;
              setState(() {
                widget.selectedIndex = 1 ;
              });
              Navigator.pushNamed(context, '/admin') ;
            },),
            ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onTap: (){
              Navigator.pushNamedAndRemoveUntil(context, "/login", (context)=>false) ;
            },
          ),

          ],
        ),
      ),
      bottomNavigationBar:
      BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.movie_filter,color: const Color.fromARGB(255, 211, 71, 61),),label: "Generated Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person,),label: "Profile",),
      ]),
      appBar: AppBar(
        title: isAdmin? Text("Admin View") : Text("Movie Explorer"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: 
      IndexedStack(
        index: widget.selectedIndex,
        children: widgets,
      ), 
    ) ;
  }
}