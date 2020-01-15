import 'dart:async';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../blocs/movie_detail_provider.dart';
import 'loading_container.dart';
import 'loading_container_list_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../actions/votecolorhelper.dart';


class MovieListTile extends StatelessWidget{
	final movieId;
	MovieListTile({this.movieId});

	Widget build(BuildContext context){
		final bloc = MovieProvider.of(context);

		return StreamBuilder(
			stream:bloc.movies,
			builder:(context,AsyncSnapshot<Map<int,Future<MovieModel>>> snapshot){
				if(!snapshot.hasData){
					return LoadingContainer();
				}
				return FutureBuilder(
					future: snapshot.data[movieId],
					builder:(context, AsyncSnapshot<MovieModel> movieSnapshot){
						if(!movieSnapshot.hasData){
							if(movieSnapshot.hasError){
								print("ERRRROR ${movieSnapshot.error}");
								print("ERRRROR ${movieSnapshot.data}");
							}
							return LoadingContainer();
						}
						return buildTile(movieSnapshot.data,context);
					}
				);
			}
		);
	}

	Widget buildTile(MovieModel movie, BuildContext context){
		return Column(
			children:[Row(
				crossAxisAlignment: CrossAxisAlignment.start,
			    mainAxisAlignment: MainAxisAlignment.start,
			    mainAxisSize:MainAxisSize.max,
				children:[VerticalDivider(width:5.0),
						InkWell(
                        	onTap:() async {
								Navigator.pushNamed(context,'/movie/details/${movie.id}');
							},
                        	child:CachedNetworkImage(
						        imageUrl: movie.poster,
						        imageBuilder:(context,imageProvider)=> Container(
						        	height:220.0,
						        	width:140.0,
						        	decoration:BoxDecoration(
						        		image: DecorationImage(
						        			image:imageProvider,
						        			fit: BoxFit.cover
						        			)
						        		),
						        	),
						        placeholder: (context, url) => LoadingContainerListImage(),
						        errorWidget: (context, url, error) => Icon(Icons.error),
							)
						),
						VerticalDivider(width:5.0),
						buildInfo(movie,context)
						],
					),
				Divider(
					height: 10.0
				)
			]
		);
	}


	Widget buildInfo(MovieModel movie,BuildContext context){
		return Column(
				textDirection: TextDirection.ltr,
				crossAxisAlignment: CrossAxisAlignment.start,
			    mainAxisAlignment: MainAxisAlignment.end,
				children:[Row(children:[imdbScore(movie,context),
										Container(child:VerticalDivider(width:10.0,
														color:Colors.blueGrey,
														thickness:0.3),
														height:30),
                        Container(
                        	width:170.0,
                            child:Text(
                              movie.title,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            	)
                        	)
                        	]
                        ),
						Divider(height:5.0),
                    	Container(
                    		width: 190.0,
	                        child: Text(
	                          movie.plot ?? '',
	                          softWrap: true,
	                          maxLines: 5,
	                          overflow: TextOverflow.ellipsis,
	                          style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13)
	                        ),
                      	),
                      	Container(
                      		child:Divider(height:3.0,
										color:Colors.blueGrey),
                      		width:200.0
                      	),
                      	Container(
                    		width: 200.0,
	                        child: Text(
	                          "Released : "+movie.released ?? '',
	                          softWrap: true,
	                          maxLines: 1,
	                          overflow: TextOverflow.ellipsis,
	                          style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10)
	                        ),
                      	),
                      	Container(
                    		width: 200.0,
	                        child: Text(
	                          "Quality : "+movie.resolution ?? '',
	                          softWrap: true,
	                          maxLines: 1,
	                          overflow: TextOverflow.ellipsis,
	                          style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10)
	                        ),
                      	),
                    	Container(
                    		width: 200.0,
	                        child: Text(
	                          "Runtime : "+movie.runtime ?? '',
	                          softWrap: true,
	                          maxLines: 1,
	                          overflow: TextOverflow.ellipsis,
	                          style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10)
	                        ),
                      	),
                      	Container(
                    		width: 200.0,
	                        child: Text(
	                          "Language: "+movie.language.join(' , ') ?? '',
	                          softWrap: true,
	                          maxLines: 1,
	                          overflow: TextOverflow.ellipsis,
	                          style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10)
	                        ),
                      	),
                      	Container(
                    		width: 200.0,
	                        child: Text(
	                          "Cast: "+movie.actors.join(' , ') ?? '',
	                          softWrap: true,
	                          maxLines: 2,
	                          overflow: TextOverflow.ellipsis,
	                          style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10)
	                        ),
                      	),
                      	Container(
                      		child:Divider(height:3.0,
										color:Colors.blueGrey),
                      		width:200.0
                      		),Divider(height:2),
                      	Row(
                      		children:movie.genre.take(3).map(showGenre).toList()
                      		),
					]
				);
	}

	Widget imdbScore(MovieModel movie,BuildContext context){
		return Stack(
			alignment:Alignment.center,
		  	children: <Widget>[
		    Center(
		      child: Container(
		        width: 30,
		        height: 30,
		        decoration: BoxDecoration(
		            color: Colors.blueGrey,
		            borderRadius: BorderRadius.circular(
		                18)),
		      ),
		    ),
		    Center(
		      child: Container(
		          width: 30,
		          height: 30,
		          child: CircularProgressIndicator(
		            strokeWidth: 3.0,
		            valueColor:
		                new AlwaysStoppedAnimation<Color>(
		                    VoteColorHelper.getColor(
		                        movie.imdbRating)),
		            backgroundColor: Colors.grey,
		            value: movie.imdbRating / 10.0,
		          )),
		    ),
		    Center(
		      child: Container(
		          width: 30,
		          height: 30,
		          child: Center(
		            child: Text(
		              movie.imdbRating
		                      .toString(),
		              style: TextStyle(
		                  fontWeight: FontWeight.w700,
		                  fontSize: 15,
		                  color: Colors.white),
		            ),
		          )),
		    )
		  ],
		);
	}

	Widget showGenre(dynamic s){
		return Container(
		    margin: EdgeInsets.only(right: 7),
		    padding: EdgeInsets.all(5),
		    child: Text(
		        s.toString(),
		        style: TextStyle(fontSize: 10),
		    ),
		    decoration: BoxDecoration(
		        border: Border.all(color: Colors.grey),
		        borderRadius: BorderRadius.circular(20)),
		);
	}
}




