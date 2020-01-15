import 'package:flutter/material.dart';
import 'screens/movie_list.dart';
import 'screens/movie_detail.dart';
import 'screens/host_select.dart';

import 'blocs/movie_detail_provider.dart';
import 'blocs/host_select_provider.dart';


class App extends StatelessWidget{
	Widget build(context){
		return MovieProvider(
			child:(HostProvider(
				child:MaterialApp(
					title:'News!',
					onGenerateRoute: routes,
					initialRoute:"/"
					)
				)
			)
		);
	}



	Route routes(RouteSettings settings){
		var params=settings.name.split('/');
		if(settings.name=='/'){
			return MaterialPageRoute(
				builder: (context){
					return HostSelect();
					}
				);
			}
		else if(params[1]=='movie'){
			if(params[2]=='details'){
				return MaterialPageRoute(
				builder: (context){
					print(params);
					return MovieDetail(
						movieId:int.parse(params[3])
						);
					}
				);
			}
		}

		else if(params[1]=="movielist"){
			return MaterialPageRoute(
			builder: (context){
				final moviesBloc = MovieProvider.of(context);
				print(params);
				moviesBloc.fetchUserMovies();
				return MoviesList();
				}
			);	
		}
	}	
}
