import 'package:flutter/material.dart';
import 'movie_detail_bloc.dart';
export 'movie_detail_bloc.dart'; 

class MovieProvider extends InheritedWidget{
	final MovieBloc bloc;

	MovieProvider({Key key, Widget child})
		: bloc = MovieBloc(),
		super(key:key,child:child);

	bool updateShouldNotify(_) => true;

	static MovieBloc of(BuildContext context){
		return (context.inheritFromWidgetOfExactType(MovieProvider) as MovieProvider).bloc;
	}

}