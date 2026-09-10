import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore =
      FirebaseFirestore.instance;

  List<Map<String, dynamic>> allMovies = [];
  List<Map<String, dynamic>> movies = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?_moviesSubscription;

  CollectionReference<Map<String, dynamic>> get movieData {
    return firebaseFirestore.collection('movies');
  }

  void listenToMovies() {
    _moviesSubscription?.cancel();
    _moviesSubscription = movieData.snapshots().listen((snapshot) {
      allMovies = snapshot.docs.map((doc) => doc.data()).toList();
      movies = List.from(allMovies);
      notifyListeners();
    });
  }

  Future<void> addMovie(Map<String, dynamic> movie) async {
    try {
      final title = movie['title'];
      if (title == null || title.toString().isEmpty) {
        throw Exception('Movie title is missing');
      }
      await movieData.doc(title.toString()).set(movie);

    } on FirebaseException catch (e) {
      print('Add movie error: ${e.code}');
    }
  }

  Future<void> deleteMovie(String movieTitle) async {
    try {
      await movieData.doc(movieTitle).delete();
    } 
    on FirebaseException catch (e) {
      print('Delete movie error: ${e.code}');
    }
  }

  Future<void> updateMovie(String movieTitle,Map<String, dynamic> updatedMovie) async {
    try {
      await movieData.doc(movieTitle).update(updatedMovie);
    } on FirebaseException catch (e) {
      print('Update movie error: ${e.code}');
    }
  }

  void filterMovies(String query) {
    query = query.toLowerCase().trim();
    if (query.isEmpty) {
      movies = List.from(allMovies);
    } 
    else {
      movies = allMovies.where((movie) {
        final title = movie['title']?.toString().toLowerCase() ?? '';
        return title.contains(query);
      }).toList();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _moviesSubscription?.cancel();
    super.dispose();
  }
}