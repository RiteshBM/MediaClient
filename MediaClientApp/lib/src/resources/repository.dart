import 'dart:async';
import 'opendb_api.dart';
import '../models/movie_model.dart';
import '../models/movie_model_mini.dart';
import 'localdb_api.dart';
import 'local_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Repository{


	List<MovieDetailProvider> DetailProviders = <MovieDetailProvider>[OpenDBProvider()];
	List<UserDataProvider> UserProvider = <UserDataProvider>[LocalDBProvider()];

	Future<List<int>> fetchUserMovies() async{
		print("fetchUserMovies");
		await sdmovie.init();
		await ldmovie.init();
		for(var userp in UserProvider){
			List<int> response = await userp.fetchUserMovies();
			if(response!=null){
				for(var id in response){
					fetchMovie(id);
				}
				return response;
			}			
		}
	}

	Future<MovieModel> fetchMovie(int id) async{
		print("fetchMovie");
		MovieModel movie;
		MovieModelMini args= await sdmovie.fetchItem(id);
		for(var source in DetailProviders){
			movie = await source.fetchMovie(args);
			if(movie!=null){
				break;
			}
		}
		return movie;
	}

	clearCache() async{
		await sdmovie.clear();
		await ldmovie.clear();
		final prefs = await SharedPreferences.getInstance();
		final createdAt = prefs.getDouble('createdAt') ?? 0;
		prefs.setDouble('createdAt',0.0);
		for(var userp in UserProvider){
			userp.refreshUserMovies();
		}
	}

	Future<List<int>>filterBy(int lb,int ub,String name) async {
		return await ldmovie.filterBy(lb,ub,name);
	}

}



abstract class MovieDetailProvider{
	Future<MovieModel> fetchMovie(MovieModelMini movie);
}

abstract class UserDataProvider{
	Future<List<dynamic>> fetchUserMovies();
	Future<int> refreshUserMovies();
}