import 'package:flutter/material.dart';
import '../blocs/movie_detail_provider.dart';

class RefreshMovieList extends StatelessWidget{
	final Widget child;

	RefreshMovieList({this.child});

	Widget build(context){
		final bloc = MovieProvider.of(context);
		return RefreshIndicator(
			child:child,
			onRefresh:() async{
				await bloc.clearCache();
				await bloc.fetchUserMovies();
			}
		);
	}


}