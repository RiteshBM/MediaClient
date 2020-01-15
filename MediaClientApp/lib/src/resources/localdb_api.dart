import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/movie_model.dart';
import '../models/movie_model_mini.dart';
import 'dart:async';
import 'repository.dart';
import 'local_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

//http://www.omdbapi.com/?t=spider+man&y=2004&apikey=af9f3219

class LocalDBProvider implements UserDataProvider{
	Client client = Client();
	
	

	Future<int> refreshUserMovies() async{
		final prefs = await SharedPreferences.getInstance();
		final _local = prefs.getString('local_ip') ?? "";
		try{
			final response = await client.get('$_local'+'/local/refresh');
			return 1;
		}catch(error){
			return 0;
		}

	}
	Future<List<int>> fetchUserMovies() async{
		final prefs = await SharedPreferences.getInstance();
		final _local = prefs.getString('local_ip') ?? "";
		try{
			final response = await client.get('$_local'+'/local/getAll');
			var temp = json.decode(response.body);
			final prefs = await SharedPreferences.getInstance();
			final createdAt = prefs.getDouble('createdAt') ?? 0;

			if(createdAt != temp['createdAt']){
				print("Refetched Local Server Data");
				prefs.setDouble('createdAt',temp['createdAt']);
				await sdmovie.clear();
				await ldmovie.clear();
				List<int> userMovies = await sdmovie.fill(temp);
				return userMovies;	
			}else{
				print("Used Old Local Server Data");
				return sdmovie.existing();
			}
		}catch(e){
			return sdmovie.existing();
		}
	}
}