import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab_2/functions.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget{
  Profile({super.key }) ;
  final FirebaseAuth auth = FirebaseAuth.instance ;

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
            // Consumer<ProfileProvider>(builder: (context,profileModel,child){
            //   // print(profileModel.user) ;
            //   // print(getFirstTwoLetters(profileModel.user[profileModel.currentUser]["name"])) ;
            //   return 
            // FutureBuilder(
            //   future: getUsers(),
            //   builder: (context, asyncSnapshot) {
            //     if(asyncSnapshot.connectionState == ConnectionState.waiting){
            //       return Center(child: CircularProgressIndicator(),) ;
            //     }
            //     List<Map<String, dynamic>> users = asyncSnapshot.data ?? [];
            //     if (users.isEmpty || profileModel.currentUser >= users.length) {
            //       return const UserAccountsDrawerHeader(
            //         accountName: Text("No User"),
            //         accountEmail: Text("No Email"),
            //         currentAccountPicture: CircleAvatar(child: Text("?")),
            //       );
            //     }
            //     return 
            //     UserAccountsDrawerHeader(
            //       currentAccountPicture: 
            //       CircleAvatar(child: 
            //         //Text(getFirstTwoLetters(profileModel.user[profileModel.currentUser]["name"])),
            //         Text(getFirstTwoLetters(users[profileModel.currentUser]["name"])),
            //                             ),
            //       accountName: 
            //       //Text(profileModel.user[profileModel.currentUser]["name"]??"no name") , accountEmail: Text(profileModel.user[profileModel.currentUser]["email"]??"no email")
            //       Text(users[profileModel.currentUser]["name"]) , 
            //       accountEmail: 
            //       Text(users[profileModel.currentUser]["email"])
            //                         );
            //   }
            // );
            // }), 
                  UserAccountsDrawerHeader(
                  currentAccountPicture: 
                  CircleAvatar(child: 
                      Text(getFirstTwoLetters(auth.currentUser!.displayName))
                    ),
                  accountName: 
                  Text("${auth.currentUser!.displayName}"),
                  accountEmail: 
                    Text("${auth.currentUser!.email}")
                  )
         
        ],
      );
  }
}