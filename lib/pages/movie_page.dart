import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab_2/pages/favorite.dart';
import 'package:lab_2/pages/movie_detailed.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MoviePage extends StatefulWidget {
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late TextEditingController _searchController;
  late List filteredList; 
  late Future<List> moviesFuture;

  @override
  void initState() {
    super.initState();
    print("moviePage init") ;
    _searchController = TextEditingController(text: "");
    moviesFuture = fetchMovieApi() ;
    
    // _searchController.addListener(() {
    //   setState(() {
    //     String query = _searchController.text.trim().toLowerCase(); 
    //     if (query.isEmpty) {
    //       filteredList = List.from(provider.movies);
    //     } else {
    //       filteredList = provider.movies.where((movie) {
    //         return movie["title"]!.toLowerCase().contains(query);
    //       }).toList();
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    print("moviePage dispose") ;
    _searchController.dispose();
  }
  Future<List> fetchMovieApi() async{
    final response = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/popular?api_key=9921a9b35d3f79a7d13dd80ef6c4d60f"));
    final data = jsonDecode(response.body) ;
    return data["results"] ;
  }

  @override
  Widget build(BuildContext context) {
    return 
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 5),
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
                labelText: "Search for movie",
                hintText: "Type movie name...",
              ),
            ),
            Expanded(
              child: 
              FutureBuilder<List>(
                future: moviesFuture,
                builder: (context, asyncSnapshot) {
                  if(asyncSnapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator() ;
                  }
                  if(asyncSnapshot.connectionState == ConnectionState.done){
                    if(asyncSnapshot.hasError){
                      return Text("Error fetching data") ;
                    }
                    else{
                      return ListView.builder(
                        itemCount: asyncSnapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: const Color.fromARGB(255, 135, 67, 162),
                            child: ListTile(
                              trailing:                              
                              Consumer<FavoriteProvider>(builder: (context,favModel,child){
                              return 
                                InkWell(
                                  child: CircleAvatar(
                                    child: IconButton(icon:Icon(Icons.favorite) ,
                                    onPressed: (){
                                      final movie = asyncSnapshot.data![index];
                                      if (favModel.fav.contains(movie)) {
                                        favModel.removeFav(movie) ;
                                      } 
                                      else {
                                        favModel.addFav(movie) ;
                                      }                          
                                    },color: favModel.fav.contains(asyncSnapshot.data![index]) ? Colors.red : Colors.white,),
                                  ),
                                );
                              }),
                              leading: CircleAvatar(backgroundImage: NetworkImage("https://image.tmdb.org/t/p/w500/${asyncSnapshot.data![index]["poster_path"]}"),), 
                              title: Text(
                                asyncSnapshot.data![index]["title"],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${asyncSnapshot.data![index]["release_date"]}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 213, 211, 211),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return MovieDetailed(
                                        title: asyncSnapshot.data![index]["title"],
                                        overview: asyncSnapshot.data![index]["overview"],
                                        imageUrl: asyncSnapshot.data![index]["poster_path"],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );

                    }
                  }
                  return Text("Anything") ;
                }
              ),
            ),
          ],
        ),
      );
  }
}