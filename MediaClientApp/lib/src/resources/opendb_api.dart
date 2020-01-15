import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/movie_model.dart';
import '../models/movie_model_mini.dart';
import 'dart:async';
import 'repository.dart';
import "local_cache.dart";


//http://www.omdbapi.com/?t=spider+man&y=2004&apikey=af9f3219

class OpenDBProvider implements MovieDetailProvider{
	Client client = Client();
	final _url='http://www.omdbapi.com';
	final _apikey='&apikey=af9f3219';

	Future<MovieModel> fetchMovie(MovieModelMini args) async{
		String title=args.title;
		int year=args.year;
		String resolution=args.resolution;
		int id=args.id;
		String filename=args.filename;
		var result = await ldmovie.fetchMovie(id);
		if(result==null){
			try{
				print("NEW FETCH");
				final response = await client.get('$_url'+'/?t='+title.split(' ').join('+')+'&y=$year&plot=full'+_apikey);
				var temp = json.decode(response.body);
				
				temp["id"]=args.id.toString();temp["resolution"]=args.resolution;
				temp["filename"]=filename;
				await ldmovie.addMovie(MovieModel.fromJson(temp));
				return ldmovie.fetchMovie(id);
			}catch(error){
				print(error);
			}
			
		}else{
			print("OLD DATA");
			return result;	
		}
		
	}
}