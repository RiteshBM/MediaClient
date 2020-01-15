import 'package:flutter/material.dart';
import '../blocs/movie_detail_provider.dart';
import '../widgets/movie_list_tile.dart';
import '../widgets/refresh_movie_list.dart';

import 'dart:async';

class MoviesList extends StatelessWidget{
	Widget build(context){
		final bloc = MovieProvider.of(context);
		return Scaffold(
				appBar:AppBar(title:Text("Your Movies")),
				body: buildList(bloc,context));
	}


	Widget buildList(MovieBloc bloc, BuildContext context){
		return StreamBuilder(
			stream: bloc.userMovies,
			builder:(context, AsyncSnapshot<List<int>> snapshot){
				if(!snapshot.hasData){
					return Center(
						child: CircularProgressIndicator()
					);
				}else{
					return RefreshMovieList(
						child:CustomScrollView(
							slivers:<Widget>[
								searchBar(bloc,context),
								SliverList(delegate:SliverChildBuilderDelegate((context,int index){
									bloc.fetchMovie(snapshot.data[index]);
									return MovieListTile(movieId: snapshot.data[index]);
										},
									childCount:snapshot.data.length
									),
								)
							]	
						)
					);
				}
			}
		);
	}

	Widget searchBar(MovieBloc bloc,BuildContext context){
		return SliverAppBar(
				automaticallyImplyLeading: false,
				backgroundColor:Colors.white,
				expandedHeight: 180.0,
					bottom: PreferredSize(                     
	                preferredSize: Size.fromHeight(110.0),      
	                child: Text(''),                           
              	),
				flexibleSpace:Container(
					decoration: new BoxDecoration(
						color: Colors.cyan[50],
						borderRadius: new BorderRadius.only(
						topLeft: const Radius.circular(20.0),
						topRight: const Radius.circular(20.0),
						bottomRight: const Radius.circular(20.0),
						bottomLeft: const Radius.circular(20.0))
					),
					height:160,
					margin:EdgeInsets.only(top:10,left:5,right:5,bottom:5),
					padding:EdgeInsets.only(top:20,left:20,right:20,bottom:5),
					child:Column(
						crossAxisAlignment:CrossAxisAlignment.start,
						children:<Widget>[Container(
							height:20,
							child:StreamBuilder<String>(
								stream:bloc.gname,
								builder:(context,snapshot){
									return TextField(
										autofocus:false,
										onChanged:bloc.name,
										decoration: InputDecoration(
											hintText: "Movie Name",
										)
									);
								}
							)
						),
						Container(height:10,width:double.infinity),
						selectImdb(bloc),
						Divider(height:20),
						Container(
							height:30.0,
							width:80.0,
							child:RaisedButton(
								color:Colors.cyan[100],
								onPressed:(){
									bloc.updateList();
									FocusScope.of(context).unfocus();
								},
								child:Center(child:Text("Search")))
						)
					]
				)
			)
		);
	}
	Widget selectImdb(MovieBloc bloc){
		return Row(
				crossAxisAlignment:CrossAxisAlignment.center,
				children:<Widget>[ 
				Container(
            		width: 100.0,
                    child: Text(
                      "IMDb Score",
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15)
                    ),
              	),
				Container(height:40,
					child:Row(
						children:<Widget>[
							Text(
								"From",
								maxLines: 1,
								softWrap: true,
								overflow: TextOverflow.ellipsis,
								style: TextStyle(
								fontWeight: FontWeight.w300,
								fontSize: 13),
							),
							Container(child:VerticalDivider(width:10.0,
								color:Colors.blueGrey,
								thickness:0.7),
								height:30),
							selectRangeL(bloc),
							Container(width:50.0,
								height:30),
							Text(
								"To",
								maxLines: 1,
								softWrap: true,
								overflow: TextOverflow.ellipsis,
								style: TextStyle(
								  fontWeight: FontWeight.w300,
								  fontSize: 13),
							),
							Container(child:VerticalDivider(width:10.0,
								color:Colors.blueGrey,
								thickness:0.7),
								height:30),
							selectRangeU(bloc)
						]
					)
				)
			]
		);
	}

	Widget selectRangeL(MovieBloc bloc){
		return	StreamBuilder<String>(
					stream:bloc.giLb,
					builder:(context,snapshot){
						return Container(
							height:40,
							width:40,
							child:DropdownButton<String>(
								value: snapshot.data,
								icon: Icon(Icons.arrow_downward),
								iconSize: 24,
								elevation: 16,
								style: TextStyle(
								color: Colors.deepPurple
									),
								underline: Container(
									height: 2,
									color: Colors.deepPurpleAccent,
									),
								onChanged: bloc.iLb,
								items: <String>['0','1','2','3','4','5','6','7','8','9','10']
								.map<DropdownMenuItem<String>>((String value) {
									return DropdownMenuItem<String>(
									value: value,
									child: Text(value),
									);
								}).toList(),
							)
						);
					}
				);
	}
	Widget selectRangeU(MovieBloc bloc){
		return	StreamBuilder<String>(
					stream:bloc.giUb,
					builder:(context,snapshot){
						return Container(
							height:40,
							width:40,
							child:DropdownButton<String>(
								value: snapshot.data,
								icon: Icon(Icons.arrow_downward),
								iconSize: 24,
								elevation: 16,
								style: TextStyle(
								color: Colors.deepPurple
									),
								underline: Container(
									height: 2,
									color: Colors.deepPurpleAccent,
									),
								onChanged: bloc.iUb,
								items: <String>['0','1','2','3','4','5','6','7','8','9','10']
								.map<DropdownMenuItem<String>>((String value) {
									return DropdownMenuItem<String>(
									value: value,
									child: Text(value),
									);
								}).toList(),
							)
						);
					}
				);
	}
}