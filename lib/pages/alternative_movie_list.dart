// import 'package:flutter/material.dart';
// import 'package:lab_2/pages/movie_detailed.dart';

// class AlternativeMovieList extends StatelessWidget{
//   AlternativeMovieList({super.key}) ;
//   final List<Map<String,String>> movies = [
//     {
//       "title" : "Inception",
//       "genre" : "Action" ,
//       "year" : "2010" 
//     },
//     {
//       "title" : "Interstellar",
//       "genre" : "Drama" ,
//       "year" : "2014" 
//     },
//     {
//       "title" : "Avatar",
//       "genre" : "Drama" ,
//       "year" : "2009" 
//     },
//     {
//       "title" : "Title: The Dark Knight",
//       "genre" : "Action" ,
//       "year" : "2008" 
//     },
//     {
//       "title" : "The Matrix",
//       "genre" : "Science Fiction" ,
//       "year" : "1999" 
//     },
//     {
//       "title" : "Spirited Away",
//       "genre" : "Animation " ,
//       "year" : "2001" 
//     },
//     {
//       "title" : "The Conjuring",
//       "genre" : "Horror" ,
//       "year" : "2013" 
//     },
//     {
//       "title" : "Superbad",
//       "genre" : "Comedy" ,
//       "year" : "2007" 
//     },
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Movie page"),
//         centerTitle: true,
//         backgroundColor: Colors.blueGrey.shade100,
//       ),
//       body: ListView.separated(
//         separatorBuilder: (context,_){
//           return Divider(color: const Color.fromARGB(255, 137, 84, 155),height: 3,) ;
//         },
//         itemCount: movies.length,
//         itemBuilder: (context,index){
//           return Card(
//             color:  Color.fromARGB(255, 135, 67, 162),
//             child: ListTile(
//               leading: CircleAvatar(child: Text("${index+1}"),),
//               title: Text(movies[index]["title"]! ,style: TextStyle(color: Colors.white),),
//               subtitle: Text("${movies[index]["genre"]}-${movies[index]["year"]}",style: TextStyle(color:const Color.fromARGB(255, 213, 211, 211))),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context){
//                   return MovieDetailed(title: movies[index]["title"]!, genre: movies[index]["genre"]!, year: movies[index]["year"]!) ;
//                 }));
//               },
//             ),
//           ) ;

//       }),
      

//     ) ;
//   }
// }