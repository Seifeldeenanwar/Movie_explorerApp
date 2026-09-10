import 'package:flutter/material.dart';
import 'package:lab_2/functions.dart';
import 'package:lab_2/providers/admin_provider.dart';
import 'package:provider/provider.dart';

class AdminView extends StatefulWidget {
  Map<String, dynamic>? movieData ;
  AdminView({super.key , this.movieData});

  @override
  State<AdminView> createState() => _AdminViewState();
}
class _AdminViewState extends State<AdminView>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>() ;
  final TextEditingController _movieTitleController = TextEditingController();
  final TextEditingController _movieOverviewController = TextEditingController();
  final TextEditingController _moviePosterUrlController = TextEditingController();
  final TextEditingController _movieRateController = TextEditingController();
  final TextEditingController _movieReleaseDateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if(widget.movieData != null){
      _movieTitleController.text = widget.movieData!['title'] ;
      _movieOverviewController.text = widget.movieData!['overview'] ;
      _moviePosterUrlController.text = widget.movieData!['poster_path'] ;
      _movieRateController.text = widget.movieData!['vote_average']!.toString() ;
      _movieReleaseDateController.text = widget.movieData!['release_date'] ;
    }
  }
  @override
  void dispose() {
    super.dispose();
    _movieTitleController.dispose();
    _movieOverviewController.dispose();
    _moviePosterUrlController.dispose();
    _movieRateController.dispose();
    _movieReleaseDateController.dispose();
  }
  Future<void> addMovie() async {
    if (!_formKey.currentState!.validate()) return ;
      String title = _movieTitleController.text.trim();
      String overview = _movieOverviewController.text.trim();
      String posterUrl = _moviePosterUrlController.text.trim();
      String rate = _movieRateController.text.trim();
      String releaseDate = _movieReleaseDateController.text.trim();

      final movieData = {
        "title": title,
        "overview": overview,
        "poster_path": posterUrl,
        "vote_average": rate,
        "release_date": releaseDate,
      };
      final adminProvider = context.read<AdminProvider>();
      if(widget.movieData != null){
        await adminProvider.updateMovie(title, movieData) ;
      }
      else{
        await adminProvider.addMovie(movieData);
      }
      if(!mounted) return ;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Changes done successfully :)"))) ;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin View"),
        centerTitle: true,
      ),
      body: Center(
        child: 
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _movieTitleController,
                  decoration: inputDecoration(
                    label: "Enter movie title",
                    hint: "Please enter the movie title",
                    icon: Icons.movie,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _movieOverviewController,
                  decoration: inputDecoration(
                    label: "Enter movie overview",
                    hint: "Please enter the movie overview",
                    icon: Icons.description,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _moviePosterUrlController,
                  decoration: inputDecoration(
                    label: "Enter movie poster URL",
                    hint: "Please enter the movie poster URL",
                    icon: Icons.image,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _movieRateController,
                  decoration: inputDecoration(
                    label: "Enter movie rate",
                    hint: "Please enter the movie rate",
                    icon: Icons.star,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _movieReleaseDateController,
                  decoration: inputDecoration(
                    label: "Enter movie release date",
                    hint: "Please enter the movie release date",
                    icon: Icons.date_range,
                  ),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                    addMovie,
                  child: const Text("Perform Admin Action"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}