import 'package:flutter/material.dart';
import 'package:lab_2/functions.dart';
import 'package:lab_2/pages/admin_view.dart';
import 'package:lab_2/pages/movie_detailed.dart';
import 'package:lab_2/providers/admin_provider.dart';
import 'package:lab_2/providers/user_data.dart';
import 'package:provider/provider.dart';

class GeneratedMovieList extends StatefulWidget {
  GeneratedMovieList({super.key});

  @override
  State<GeneratedMovieList> createState() => _GeneratedMovieListState();
}
class _GeneratedMovieListState extends State<GeneratedMovieList> {
  late TextEditingController _searchController ;

  bool isAdmin = false ;
  Future<void> checkAdmin() async {
    final userProvider = context.read<UsersData>();
    final admin = await userProvider.getIsAdmin();
    if(!mounted) return ;
    setState(() {
      isAdmin = admin ;
    });
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: "") ;
    _searchController.addListener((){
      final adminProvider = context.read<AdminProvider>() ;
      String query = _searchController.text.trim();
      adminProvider.filterMovies(query) ;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAdmin();
      context.read<AdminProvider>().listenToMovies();
    });

  }
  @override
  Widget build(BuildContext context) {
    return 
      SafeArea(
        child: Center(
          child:
          Column(
            children: [
              if(isAdmin)
              FloatingActionButton.small(
                onPressed: (){
                Navigator.pushNamed(context, '/admin') ;
              } ,backgroundColor: Colors.blueGrey.shade100,child: Icon(Icons.add)
              ),
              SizedBox(height: 5,),
              TextField(
                controller: _searchController ,
                decoration: inputDecoration(label: "filter movies", hint: "filter by movie title", icon: Icons.filter_list)
                ,
              ),
              SizedBox(height: 10,),
              Consumer<AdminProvider>(
                builder: (context, adminProvider, child) {
                  final generatedMovies = adminProvider.movies;
                  if (generatedMovies.isEmpty) {
                    return const Center(child: Text("No generated movies available."));
                  }
                  return 
                  Expanded(
                    child: ListView.builder(
                      itemCount: generatedMovies.length,
                      itemBuilder: (context, index) {
                        final movie = generatedMovies[index];
                        final posterUrl = movie["poster_path"];
                        return Card(
                          color: const Color.fromARGB(255, 135, 67, 162),
                          child: ListTile(
                            title: Text(movie["title"] ?? "No Title", style: const TextStyle(color: Colors.white)),
                            subtitle: 
                              Row(children: [Text("${movie["vote_average"]}",style: TextStyle(color: Color.fromARGB(255, 213, 211, 211),),),
                              SizedBox(width: 5,),
                              Icon(Icons.star,color: Colors.amber,)
                              ],),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: posterUrl != null && posterUrl.isNotEmpty? NetworkImage(posterUrl.toString()) : null,
                              child: posterUrl == null || posterUrl.isEmpty ? const Icon(Icons.movie ,color :Colors.red) : null,
                            ),
                            trailing:
                            isAdmin? 
                            PopupMenuButton(
                              iconColor: Colors.white,
                              itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Navigator.push<Map<String, dynamic>>(context, MaterialPageRoute(builder: (context) => AdminView(movieData: movie,)));
                              } 
                              else if (value == 'delete') {
                                await adminProvider.deleteMovie(movie["title"] ?? "");
                                showMessage("${movie["title"]} deleted successfully");
                              }
                            },
                          ):
                            Consumer<UsersData>(builder: (context,favModel,child){
                              final isFavorite = favModel.fav.any((element) => element['title'] == movie['title']);
                            return 
                              InkWell(
                                child: CircleAvatar(
                                  child: IconButton(icon:Icon(Icons.favorite) ,
                                  onPressed: (){
                                    if (isFavorite) {
                                      favModel.deleteFavorite(movie['title']!) ;
                                    } 
                                    else {
                                      favModel.addFavorite(movie) ;
                                    }                          
                                  },color: isFavorite ? Colors.red : Colors.white,),
                                ),
                              );
                            }),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder:(context) =>
                            MovieDetailed(date: movie['release_date'],
                            imageUrl: movie['poster_path'] ,
                            overview:movie['overview'],
                            rating: double.parse(movie['vote_average']),title: movie['title']
                            ),));
                          },
                        )
                        );
                      },
                    ),
                  );
                },
                ),
                
            ],
          ),
          ),
      );
  }
}