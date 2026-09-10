import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersData extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late bool _isAdmin;

  List<Map<String, dynamic>> fav = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _favoritesSubscription;

  DocumentReference<Map<String, dynamic>> get userData {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No user is logged in');
    }
    return firebaseFirestore.collection('users').doc(user.uid);
  }

  CollectionReference<Map<String, dynamic>> get favorites {
    return userData.collection('favorites');
  }

  Future<void> addUserData(String name,String email,bool admin) async {
    await userData.set({'name': name,'email': email,'admin': admin,});
    notifyListeners();
  }

  void listenToFavorites() {
    try{
    _favoritesSubscription?.cancel();
    _favoritesSubscription = favorites.snapshots().listen((snapshot) {
      fav = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    });
    }
    catch(e){
      print("listening to favorite error $e") ;
    }
  }

  Future<void> addFavorite(Map<String, dynamic> movie) async {
    final title = movie['title'];
    if (title == null || title.toString().isEmpty) {
      throw Exception('Movie title is missing');
    }
    try{
      await favorites.doc(title.toString()).set(movie);
      fav.add(movie) ;
    }
    catch(e){
      print("add to favorite error $e") ;
    }
  }

  Future<void> deleteFavorite(String movieTitle,) async {
    try{
      await favorites.doc(movieTitle).delete();
      fav.removeWhere((movie)=>movie["title"] == movieTitle) ;
    }
    catch(e){
      print("delete from favorite error $e") ;
    }
  }
  Future<bool> getIsAdmin() async{
    try{
      final snapshot = await userData.get();
      _isAdmin = snapshot.data()?['admin'] ?? false;
      notifyListeners();
      return _isAdmin;
    }
    catch(e){
      print("error while check admin $e") ;
    }
    return false ;
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}