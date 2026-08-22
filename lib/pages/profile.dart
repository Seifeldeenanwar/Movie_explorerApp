import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget{
  const Profile({super.key }) ;

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
  Future<List<Map<String,dynamic>>> getUsers() async{
    final prefs = await SharedPreferences.getInstance() ;
    String users = prefs.getString("users") ?? "" ;
    if(users.isEmpty){
      return [] ;
    }
    List<dynamic> decodedUsers = jsonDecode(users) ;
    return decodedUsers.map((e)=>Map<String,dynamic>.from(e)).toList() ;
  }
  @override
  Widget build(BuildContext context) {
    return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Consumer<ProfileProvider>(builder: (context,profileModel,child){
              // print(profileModel.user) ;
              // print(getFirstTwoLetters(profileModel.user[profileModel.currentUser]["name"])) ;
              return 
            FutureBuilder(
              future: getUsers(),
              builder: (context, asyncSnapshot) {
                if(asyncSnapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),) ;
                }
                List<Map<String, dynamic>> users = asyncSnapshot.data ?? [];
                if (users.isEmpty || profileModel.currentUser >= users.length) {
                  return const UserAccountsDrawerHeader(
                    accountName: Text("No User"),
                    accountEmail: Text("No Email"),
                    currentAccountPicture: CircleAvatar(child: Text("?")),
                  );
                }
                return UserAccountsDrawerHeader(
                  currentAccountPicture: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: 
                        //Text(getFirstTwoLetters(profileModel.user[profileModel.currentUser]["name"])),
                        Text(getFirstTwoLetters(users[profileModel.currentUser]["name"])),
                        ),
                    ],
                  ),
                  accountName: 
                  //Text(profileModel.user[profileModel.currentUser]["name"]??"no name") , accountEmail: Text(profileModel.user[profileModel.currentUser]["email"]??"no email")
                  Text(users[profileModel.currentUser]["name"]) , accountEmail: Text(users[profileModel.currentUser]["email"])
                  );
              }
            );
            }),          
        ],
      );
  }
}