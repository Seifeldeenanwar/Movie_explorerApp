import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lab_2/pages/favorite.dart';
import 'package:lab_2/pages/movie_detailed.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MoviePage extends StatefulWidget {
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late TextEditingController _searchController;
  late Future<List> moviesFuture;
  List movies = [] ;
  List filteredList = [];
  final String? token = dotenv.env["MovieToken"];
  @override
  void initState() {
    super.initState();
    print("moviePage init") ;
    _searchController = TextEditingController(text: "");
    moviesFuture = fetchMovieApi() ;
    
    _searchController.addListener(() {
      setState(() {
        String query = _searchController.text.trim().toLowerCase(); 
        if (query.isEmpty) {
          filteredList = List.from(movies);
        } else {
          filteredList = movies.where((movie) {
            return movie["title"]!.toLowerCase().contains(query);
          }).toList();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("moviePage dispose") ;
    _searchController.dispose();
  }
  Future<List> fetchMovieApi() async{
    List fetchedMovies = [] ;
    for(int i = 1 ; i <= 4 ; i++){
      final response = await http.get(Uri.parse("https://api.themoviedb.org/3/discover/movie?api_key=$token&page=$i"));
      final data = jsonDecode(response.body) ;
      fetchedMovies.addAll(data["results"]) ;
    }
    return fetchedMovies ;
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
            // Container(
            //   decoration: BoxDecoration(
            //     color: const Color.fromARGB(255,135,67,162),
            //     borderRadius: BorderRadius.circular(15)

            //   ),
            //   margin: EdgeInsets.all(6),
            //   height: 100,
            // child: 
            // GridView.count(crossAxisCount: 4,
            // children: [
            //   MaterialButton(onPressed: (){}, child: Text("Poupular",style: TextStyle(color: Colors.white),),),
            //   MaterialButton(onPressed: (){}, child: Text("Now Playing",style: TextStyle(color: Colors.white),)),
            //   MaterialButton(onPressed: (){}, child: Text("Upcoming",style: TextStyle(color: Colors.white),)),
            //   MaterialButton(onPressed: (){}, child: Text("Top Rated",style: TextStyle(color: Colors.white),))
            // ],)
            // ),
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
                      if (movies.isEmpty) {
                        movies = asyncSnapshot.data!;
                        filteredList = List.from(movies);
                      }
                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: const Color.fromARGB(255, 135, 67, 162),
                            child: ListTile(
                              trailing:                              
                              Consumer<UsersData>(builder: (context,favModel,child){
                              return 
                                InkWell(
                                  child: CircleAvatar(
                                    child: IconButton(icon:Icon(Icons.favorite) ,
                                    onPressed: (){
                                      final movie = filteredList[index];
                                      if (favModel.fav.any((m)=>m["title"] == movie["title"])) {
                                        favModel.deleteFavorite(movie['title']!) ;
                                      } 
                                      else {
                                        favModel.addFavorite(movie) ;
                                      }                          
                                    },color: favModel.fav.any((element) => element['title'] == filteredList[index]['title']) ? Colors.red : Colors.white,),
                                  ),
                                );
                              }),
                              leading: CircleAvatar(radius: 25,backgroundImage: NetworkImage("https://image.tmdb.org/t/p/w500/${filteredList[index]["poster_path"]}"),), 
                              title: Text(
                                filteredList[index]["title"],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: 
                              Row(children: [Text("${filteredList[index]["vote_average"]}",style: TextStyle(color: Color.fromARGB(255, 213, 211, 211),),),
                              SizedBox(width: 5,),
                              Icon(Icons.star,color: Colors.amber,)
                              ],),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return MovieDetailed(
                                        title: filteredList[index]["title"],
                                        overview: filteredList[index]["overview"],
                                        imageUrl: "https://image.tmdb.org/t/p/w500/${filteredList[index]["poster_path"]}",
                                        rating : filteredList[index]["vote_average"],
                                        date: filteredList[index]["release_date"],
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