import 'dart:convert';

class MovieModel{
	final String 		title;
	final int 			year;			
	final String 		rated;
	final String		released;
	final String		runtime;
	final List<dynamic> genre;
	final List<dynamic> director;
	final List<dynamic> actors;
	final List<dynamic>	writer;
	final String		plot;
	final List<dynamic>	language;
	final String		country;
	final String		awards;
	final String		poster;
	final List<dynamic> ratings;
	final int			metascore;
	final double		imdbRating;
	final int			imdbVotes;
	final String		imdbId;
	final String		type;
	final String		dvd;
	final String		boxOffice;
	final String		production;
	final String		website;
	final bool			response;
	final int			id;
	final String		resolution;
	final String		filename;



	MovieModel.fromJson(Map<String,dynamic> parsedJson):
		title		= parsedJson['Title'],
		year		= int.parse(parsedJson['Year']) ?? 0,
		rated		= parsedJson['Rated'],
		released	= parsedJson['Released'],
		runtime		= parsedJson['Runtime'],
		genre		= parsedJson['Genre'].split(',').map((a)=>a.trim()).toList(),
		plot		= parsedJson['Plot'],
		director	= parsedJson['Director'].split(',').map((a)=>a.trim()).toList(),
		writer		= parsedJson['Writer'].split(',').map((a)=>a.trim()).toList(),
		actors		= parsedJson['Actors'].split(',').map((a)=>a.trim()).toList(),
		language	= parsedJson['Language'].split(',').map((a)=>a.trim()).toList(),
		country		= parsedJson['Country'],
		awards		= parsedJson['Awards'],
		poster		= parsedJson['Poster'],
		ratings		= parsedJson['Ratings'] ?? [],
		metascore	= parsedJson['Metascore']!="N/A" ? int.parse(parsedJson['Metascore']) : 0,
		imdbRating	= parsedJson['imdbRating']!="N/A" ? double.parse(parsedJson['imdbRating']) : 0,
		imdbVotes	= int.parse(parsedJson['imdbVotes'].replaceAll(',','')) ?? 0,
		imdbId		= parsedJson['imdbID'],
		dvd			= parsedJson['DVD'],
		boxOffice	= parsedJson['BoxOffice'],
		type		= parsedJson['Type'],
		production	= parsedJson['Production'],
		website		= parsedJson['Website'],
		response	= parsedJson['Response']=='True',
		id			= int.parse(parsedJson['id']) ?? 0,
		resolution	= parsedJson['resolution'],
		filename	= parsedJson['filename'];



	MovieModel.fromDb(Map<String,dynamic> parsedJson):
		title		= parsedJson['title'],
		year		= parsedJson['year'] ?? 0,
		rated		= parsedJson['rated'],
		released	= parsedJson['released'],
		runtime		= parsedJson['runtime'],
		genre		= jsonDecode(parsedJson['genre']),
		plot		= parsedJson['plot'],
		director	= jsonDecode(parsedJson['director']),
		writer		= jsonDecode(parsedJson['writer']),
		actors		= jsonDecode(parsedJson['actors']),
		language	= jsonDecode(parsedJson['language']),
		country		= parsedJson['country'],
		awards		= parsedJson['awards'],
		poster		= parsedJson['poster'],
		ratings		= jsonDecode(parsedJson['ratings']),
		metascore	= parsedJson['metascore'] ?? 0,
		imdbRating	= double.parse(parsedJson['imdbRating'].toString()),
		imdbVotes	= parsedJson['imdbVotes'] ?? 0,
		imdbId		= parsedJson['imdbID'],
		dvd			= parsedJson['dVD'],
		boxOffice	= parsedJson['boxOffice'],
		type		= parsedJson['type'],
		production	= parsedJson['production'],
		website		= parsedJson['website'],
		response	= parsedJson['response']==1,
		id			= parsedJson['id'],
		resolution	= parsedJson['resolution'],
		filename	= parsedJson['filename'];



		Map<String,dynamic> toMap(){
			return <String,dynamic>{
				"title":title,
				"rated":rated,
				"released":released,
				"runtime":runtime,
				"plot":plot,
				"country":country,
				"awards":awards,
				"poster":poster,
				"imdbId":imdbId,
				"type":type,
				"dvd":dvd,
				"boxOffice":boxOffice,
				"production":production,
				"website":website,
				"resolution":resolution,
				"year":year,
				"metascore":metascore,
				"imdbVotes":imdbVotes,
				"id":id,
				"imdbRating":imdbRating,
				"genre":jsonEncode(genre),
				"director":jsonEncode(director),
				"actors":jsonEncode(actors),
				"writer":jsonEncode(writer),
				"language":jsonEncode(language),
				"ratings":jsonEncode(ratings),
				"response": response ? 1:0,
				"filename":filename
			};
		}

}