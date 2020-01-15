import 'dart:convert';

class MovieModelMini{
	final String 		title;
	final int 			year;			
	final int			id;
	final String		resolution;	
	final String		filename;


	MovieModelMini.fromJson(Map<String,dynamic> parsedJson):
		title		= parsedJson['title'],
		year		= int.parse(parsedJson['year']) ?? 0,
		id			= int.parse(parsedJson['id']) ?? 0,
		resolution	= parsedJson['resolution'],
		filename	= parsedJson['filename'];


	MovieModelMini.fromDb(Map<String,dynamic> parsedJson):
		title		= parsedJson['title'],
		year		= parsedJson['year'] ?? 0,
		id			= parsedJson['id'] ?? 0,
		resolution	= parsedJson['resolution'],
		filename	= parsedJson['filename'];



		Map<String,dynamic> toMap(){
			return <String,dynamic>{
				"title":title,
				"resolution":resolution,
				"year":year,
				"id":id,
				"filename":filename
			};
		}

}