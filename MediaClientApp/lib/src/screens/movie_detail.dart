import 'dart:async';
import'dart:convert';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../blocs/movie_detail_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../actions/votecolorhelper.dart';
import 'package:android_intent/android_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetail extends StatelessWidget{
	final movieId;
	MovieDetail({this.movieId});

	Widget build(BuildContext context){
		final bloc = MovieProvider.of(context);
		return buildBody(bloc);
	}

	Widget buildBody(MovieBloc bloc){
		return StreamBuilder(
			stream:bloc.movies,
			builder:(context,AsyncSnapshot<Map<int,Future<MovieModel>>> snapshot){
				if(!snapshot.hasData){
					return Text('Loading');
				}
				return FutureBuilder(
					future: snapshot.data[movieId],
					builder:(context, AsyncSnapshot<MovieModel> movieSnapshot){
						if(!movieSnapshot.hasData){
							if(movieSnapshot.hasError){
								print("ERRRROR ${movieSnapshot.error}");
								print("ERRRROR ${movieSnapshot.data}");
							}
							return Text('Loading');
						}
						return showBody(movieSnapshot.data,context);
					}
				);
			}
		);
	}


	Widget showBody(MovieModel movie, BuildContext context){
		return Scaffold(
			body: SingleChildScrollView(
				child: Column(
					children: <Widget>[
						HomeScreenTopPart(movie,context),
						HomeScreenBottomPart(movie,context),

					]
				)
			)
		);
	}


	Widget HomeScreenTopPart(MovieModel movie,BuildContext context){
		return Container(
			height: 420.0,
			child:Stack(
				children: <Widget>[
					ClipPath(
						clipper: Mclipper(),
						child:Container(
							height:370.0,
							decoration: BoxDecoration(color: Colors.white,boxShadow:[
								BoxShadow(
									color: Colors.black12,
									offset: Offset(0.0,10.0),
									blurRadius: 10.0)
							]),
							child: Stack(
								children:<Widget>[
									CachedNetworkImage(
							        imageUrl: movie.poster,
							        imageBuilder:(context,imageProvider)=> Container(
							        	decoration:BoxDecoration(
							        		image: DecorationImage(
							        			image:imageProvider,
							        			fit: BoxFit.cover,
							        			)
							        		),
							        	),
									),
									Container(
										height: double.infinity,
										width: double.infinity,
										decoration: BoxDecoration(
											gradient: LinearGradient(
												colors:[
													const Color(0x00000000),
													const Color(0xD9333333) 
												],
												stops:[
													0.0,
													0.9
												],
												begin: FractionalOffset(0.0,0.0),
												end: FractionalOffset(0.0,1.0))),
										child: Padding(
												padding: EdgeInsets.only(top:120.0,left:95.0),
												child: Column(
													mainAxisAlignment:MainAxisAlignment.center,
													crossAxisAlignment:CrossAxisAlignment.end,
													children:<Widget>[
													Text(
														movie.title,
														style:TextStyle(
															color: Colors.white,
															fontSize: 45.0,
															fontFamily: "SF-Pro-Display-Bold"
															)
														)
													]
												)
												
											)
										)
								]
							)
						)
					),
					Positioned(
						top:370.0,
						right:-20.0,
						child: FractionalTranslation(
							translation: Offset(0.0,-0.5),
							child:Row(
								children:<Widget>[
									imdbScore(movie,context),
									SizedBox(
										width:12.0
									),
									ClipRRect(
										borderRadius: BorderRadius.circular(30.0),
										child:RaisedButton(
											color:Color(0xFFE52020),
											padding:EdgeInsets.symmetric(vertical:15.0,horizontal:80.0),
											onPressed:(){travel(movie);},
											child:Row(
												children:<Widget>[
													Text("Watch",
														style: TextStyle(color: Colors.white,fontSize:15.0,fontFamily:"SF-Pro-Display-Bold")
													),
													SizedBox(
														width: 5.0
													)
												]
											)
										)
									),
								]
							),
						)
					)

				]
			)
		);

	}
	Widget HomeScreenBottomPart(MovieModel movie,BuildContext context){
		return Container(
			child:Column(
				children:[
					showPlot(movie,context),
					showAwards(movie,context),
					Divider(height:8.0),
					movie.ratings.length>0 ? showRatings(movie,context) : noRatings(),
					showMinors(movie,context)
				]
			)
		);	
	}

	Widget showPlot(MovieModel movie,BuildContext context){
		return Column(
			crossAxisAlignment:CrossAxisAlignment.start,
			children:[

				Container(
                    width:double.infinity,
                    padding: EdgeInsets.only(left:15.0),
					child:Text(
                      	"Overview",
                      	softWrap: true,
                      	maxLines: 1,
                      	overflow: TextOverflow.ellipsis,
                      	style: TextStyle(
                      	    fontWeight: FontWeight.w700,
                      	    fontSize: 17)
                    	)
					),
				Container(
                    width:double.infinity,
                    padding: EdgeInsets.all(15.0),
					child:Text(
                      	movie.plot ?? '',
                      	softWrap: true,
                      	maxLines: 20,
                      	overflow: TextOverflow.ellipsis,
                      	style: TextStyle(
                      	    fontWeight: FontWeight.w400,
                      	    fontSize: 13)
                    	)
					)
			]
		);
	}
	Widget showAwards(MovieModel movie,BuildContext context){
		return Column(
			crossAxisAlignment:CrossAxisAlignment.start,
			children:[

				Container(
                    width:double.infinity,
                    padding: EdgeInsets.only(left:15.0),
					child:Text(
                      	"Awards",
                      	softWrap: true,
                      	maxLines: 1,
                      	overflow: TextOverflow.ellipsis,
                      	style: TextStyle(
                      	    fontWeight: FontWeight.w700,
                      	    fontSize: 17)
                    	)
					),
				Container(
                    width:double.infinity,
                    padding: EdgeInsets.only(left:15.0,top:5.0,bottom:5.0),
					child:Text(
                      	movie.awards ?? '',
                      	softWrap: true,
                      	maxLines: 2,
                      	overflow: TextOverflow.ellipsis,
                      	style: TextStyle(
                      	    fontWeight: FontWeight.w400,
                      	    fontSize: 13)
                    	)
					)
			]
		);
	}

		Widget showMinors(MovieModel movie,BuildContext context){
		return Column(
			crossAxisAlignment:CrossAxisAlignment.start,
			children:[
				Divider(height:15.0),
				Row(children:[
					Container(
	                    width:70,
	                    padding: EdgeInsets.only(left:15.0,top:5.0),
						child:Text(
	                      	"Cast",
	                      	softWrap: true,
	                      	maxLines: 1,
	                      	overflow: TextOverflow.ellipsis,
	                      	style: TextStyle(
	                      	    fontWeight: FontWeight.w700,
	                      	    fontSize: 15)
	                    	)
						),
					Container(
	                    width:280,
	                    padding: EdgeInsets.only(left:15.0),
						child:Text(
	                      	movie.actors.join(' , ') ?? '',
	                      	softWrap: true,
	                      	maxLines: 4,
	                      	overflow: TextOverflow.ellipsis,
	                      	style: TextStyle(
	                      	    fontWeight: FontWeight.w400,
	                      	    fontSize: 11)
	                    	)
						)
					]
				),Divider(height:15.0),
				Row(children:[
					Container(
	                    width:70,
	                    padding: EdgeInsets.only(left:15.0),
						child:Text(
	                      	"Genre",
	                      	softWrap: true,
	                      	maxLines: 1,
	                      	overflow: TextOverflow.ellipsis,
	                      	style: TextStyle(
	                      	    fontWeight: FontWeight.w700,
	                      	    fontSize: 15)
	                    	)
						),
					Row(children:movie.genre.take(5).map(showGenre).toList())
						
					]
				),Divider(height:15.0),
				Row(children:[
					Container(
	                    width:70,
	                    padding: EdgeInsets.only(left:15.0),
						child:Text(
	                      	"Director",
	                      	softWrap: true,
	                      	maxLines: 1,
	                      	overflow: TextOverflow.ellipsis,
	                      	style: TextStyle(
	                      	    fontWeight: FontWeight.w700,
	                      	    fontSize: 15)
	                    	)
						),
					Container(
	                    width:280,
	                    padding: EdgeInsets.only(left:15.0),
						child:Text(
	                      	movie.director.join(' , ') ?? '',
	                      	softWrap: true,
	                      	maxLines: 4,
	                      	overflow: TextOverflow.ellipsis,
	                      	style: TextStyle(
	                      	    fontWeight: FontWeight.w400,
	                      	    fontSize: 11)
	                    	)
						)
					]
				),Divider(height:15.0),
				Row(children:[
					Container(
	                    width:70,
	                    padding: EdgeInsets.only(left:15.0),
						child:Text(
	                      	"Writer",
	                      	softWrap: true,
	                      	maxLines: 1,
	                      	overflow: TextOverflow.ellipsis,
	                      	style: TextStyle(
	                      	    fontWeight: FontWeight.w700,
	                      	    fontSize: 15)
	                    	)
						),
					Container(
	                    width:280,
	                    padding: EdgeInsets.only(left:15.0),
						child:Text(
	                      	movie.writer.join(' , ') ?? '',
	                      	softWrap: true,
	                      	maxLines: 4,
	                      	overflow: TextOverflow.ellipsis,
	                      	style: TextStyle(
	                      	    fontWeight: FontWeight.w400,
	                      	    fontSize: 11)
	                    	)
						)
					]
				)
			]
		);
	}
	Widget showRatings(MovieModel movie,BuildContext context){
		return Column(
			crossAxisAlignment:CrossAxisAlignment.start,
			children:[
				showRatingHead(movie,context),
				showRatingBody(movie,context),
				VerticalDivider(width:10.0,
								color:Colors.blueGrey,
								thickness:0.3),
			]
		);
	}

	Widget showRatingHead(MovieModel movie,BuildContext context){
		return Container(
                    width:70,
                    padding: EdgeInsets.only(left:15.0,bottom:5.0),
					child:Text(
                      	"Ratings",
                      	softWrap: true,
                      	maxLines: 1,
                      	overflow: TextOverflow.ellipsis,
                      	style: TextStyle(
                      	    fontWeight: FontWeight.w700,
                      	    fontSize: 15)
                    	)
					);
	}
	Widget showRatingBody(MovieModel movie,BuildContext context){
		return Container(
			padding:EdgeInsets.only(left:45.0),
			child:Column(
				crossAxisAlignment:CrossAxisAlignment.start,
				children:movie.ratings.map(indiRating).toList()
				)
			);
	}

	Widget indiRating(dynamic rating){
		//rating=json.decode(rating);
		return Row(
			children:[
				Container(width:200,child:Text(
					              	rating["Source"],
					              	softWrap: true,
					              	maxLines: 1,
					              	overflow: TextOverflow.ellipsis,
					              	style: TextStyle(
					              	    fontWeight: FontWeight.w400,
					              	    fontSize: 15)
					            	)
				),
				VerticalDivider(width:10.0,
								color:Colors.blueGrey,
								thickness:0.3),
				Text(
	              	rating["Value"],
	              	softWrap: true,
	              	maxLines: 1,
	              	overflow: TextOverflow.ellipsis,
	              	style: TextStyle(
	              	    fontWeight: FontWeight.w700,
	              	    fontSize: 12)
	            	),
			]
		);
	}

	Widget noRatings(){
		return Container(
                width:70,
                padding: EdgeInsets.only(left:15.0),
				child:Text(
                  	"No Ratings",
                  	softWrap: true,
                  	maxLines: 1,
                  	overflow: TextOverflow.ellipsis,
                  	style: TextStyle(
                  	    fontWeight: FontWeight.w700,
                  	    fontSize: 15)
                	)
				);
	}

	Widget imdbScore(MovieModel movie,BuildContext context){
		return Stack(
			alignment:Alignment.center,
		  	children: <Widget>[
		    Center(
		      child: Container(
		        width: 50,
		        height: 50,
		        decoration: BoxDecoration(
		            color: Colors.blueGrey,
		            borderRadius: BorderRadius.circular(
		                25)),
		      ),
		    ),
		    Center(
		      child: Container(
		          width: 50,
		          height: 50,
		          child: CircularProgressIndicator(
		            strokeWidth: 6.0,
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
		          width: 50,
		          height: 50,
		          child: Center(
		            child: Text(
		              movie.imdbRating
		                      .toString(),
		              style: TextStyle(
		                  fontWeight: FontWeight.w700,
		                  fontSize: 20,
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

	void travel(MovieModel movie)async{
		final prefs = await SharedPreferences.getInstance();
		final _local = prefs.getString('local_ip') ?? "";
		AndroidIntent intent = AndroidIntent(
		action: 'action_view',
		data:"$_local/movies/"+movie.filename.toString(),
		package:"com.mxtech.videoplayer.ad"
		);
		await intent.launch();
	}
}

class Mclipper extends CustomClipper<Path>{
	Path getClip(Size size){
		Path path = new Path();
		path.lineTo(0.0,size.height - 100.0);

		var controlpoint = Offset(35.0, size.height);
		var endpoint = Offset(size.width/2,size.height);

		path.quadraticBezierTo(
			controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);
		path.lineTo(size.width,size.height);
		path.lineTo(size.width, 0.0);

		return path;
	}
	bool shouldReclip(CustomClipper<Path> oldClipper){
		return true;
	}
}
