import 'package:flutter/material.dart';

class MovieDetailed extends StatelessWidget{
  late String title ;
  late String overview;
  late String imageUrl ;
  MovieDetailed({super.key , required this.title , required this.overview ,required this.imageUrl}) ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title movie",style: TextStyle(fontSize: 16),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: 
      ColoredBox(
        color: const Color.fromARGB(255, 65, 54, 75),
        child: 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child:  
              SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        // color: Colors.white,
                        height: 250,
                        width: 190,
                        child: Image.network("https://image.tmdb.org/t/p/w500/$imageUrl",)),
                    ),
                    ListTile(title: 
                    Text("Movie title: $title" ,style: TextStyle(color: Colors.white ,fontSize: 16 ,fontWeight: FontWeight.bold),),
                    subtitle: 
                    Text("Overview: $overview",style: TextStyle(color: Colors.white,fontSize: 12 ,fontWeight: FontWeight.bold)) ,
                    )
                
                                    ],
                ),
              ),        
          ),
        ),
      ),

    );
  }
}