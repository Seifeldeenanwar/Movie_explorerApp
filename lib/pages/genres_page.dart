import 'package:flutter/material.dart';

class GenresPage extends StatelessWidget{
  GenresPage({super.key}) ;
  List<String> genres = ["Action" ,"Comedy" ,"Adventure" ,"Science fiction" ,"Drama" ,"Horrer"] ;
  @override
  Widget build(BuildContext context) {
    return 
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: GridView.count(
          childAspectRatio: 1.5,
          crossAxisCount: 2,
          children: [
            ...List.generate(6, (index){
              return Card(
                color:  const Color.fromARGB(255, 135, 67, 162),
                child: ListTile(
                  title: Text(genres[index],style: TextStyle(color: Colors.white),),
                ),
              ) ;
        
            })
        
        ],
        ),
      );
  }
}