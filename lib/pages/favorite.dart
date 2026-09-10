import 'package:flutter/material.dart';
import 'package:lab_2/providers/favorite_provider.dart';
import 'package:lab_2/providers/user_data.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget{
  FavoritePage({super.key }) ;
  @override
  State<FavoritePage> createState() => FavState() ;
}

class FavState extends State<FavoritePage>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersData>().listenToFavorites();
    });

  }
  @override
  void dispose() {
    super.dispose();
  }
  Future<void> loadFav() async{
    final userData = context.read<UsersData>();
    userData.listenToFavorites();
  }
    @override
  Widget build(BuildContext context) {
    return 
      Consumer<UsersData>(builder: (context,favModel ,child){
      return
      favModel.fav.isEmpty?
      Center(child: 
        Text("No movie was added to favorite")
      )
      :
      GridView.count(
          childAspectRatio: 2,
          crossAxisCount: 1,
          children: [
            ...List.generate(favModel.fav.length, (index){
              bool isFullUrl = favModel.fav[index]["poster_path"].toString().startsWith('http') ;
              return Card(
                color: const Color.fromARGB(255, 135, 67, 162),
                child: ListTile(
                  title: Text(favModel.fav[index]["title"]!,style: TextStyle(color: Colors.white),),
                  subtitle: Text("${favModel.fav[index]["release_date"]}",style: TextStyle(color:const Color.fromARGB(255, 213, 211, 211))),
                  leading: CircleAvatar(radius: 30,backgroundImage: !isFullUrl? NetworkImage("https://image.tmdb.org/t/p/w500/${favModel.fav[index]["poster_path"]}"):null,
                  child: isFullUrl? Icon(Icons.favorite,color: Colors.red,):null,
                  ),
                  trailing: ElevatedButton.icon(onPressed: (){
                      Map<String, dynamic> removedMovie = favModel.fav[index];
                      favModel.deleteFavorite(removedMovie['title']!) ;
                  }, label: Text("Remove") ,icon: Icon(Icons.remove_circle),),
                ),
              ) ;
            })
            
          ],

        );
        
      });
  }

}