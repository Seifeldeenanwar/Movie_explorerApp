import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<dynamic> fav = [] ;
  void addFav(Map<String,dynamic> movie){
    fav.add(movie) ;
    notifyListeners() ;
  }
  void removeFav(Map<String,dynamic> movie){
    fav.remove(movie) ;
    notifyListeners() ;
  }
  void clearFav(){
    fav.clear() ;
    notifyListeners() ;
  }
  
}