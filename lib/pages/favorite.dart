import 'package:flutter/material.dart';
import 'package:lab_2/providers/favorite_provider.dart';
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
  }
  @override
  void dispose() {
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    return 
      Consumer<FavoriteProvider>(builder: (context,favModel ,child){
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
              return Card(
                color: const Color.fromARGB(255, 135, 67, 162),
                child: ListTile(
                  title: Text(favModel.fav[index]["title"]!,style: TextStyle(color: Colors.white),),
                  subtitle: Text("${favModel.fav[index]["release_date"]}",style: TextStyle(color:const Color.fromARGB(255, 213, 211, 211))),
                  leading: CircleAvatar(radius: 30,backgroundImage: NetworkImage("https://image.tmdb.org/t/p/w500/${favModel.fav[index]["poster_path"]}"),),
                  trailing: ElevatedButton.icon(onPressed: (){
                      Map<String, dynamic> removedMovie = favModel.fav[index];
                      favModel.removeFav(removedMovie) ;
                  }, label: Text("Remove") ,icon: Icon(Icons.remove_circle),),
                ),
              ) ;
            })
            
          ],

        );
        
      });
  }

}