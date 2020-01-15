import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/movie_model.dart';
import '../models/movie_model_mini.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


//http://www.omdbapi.com/?t=spider+man&y=2004&apikey=af9f3219

class SDmovie{
	Database db;
	SDmovie(){
		//init();
	}

	void init() async{
		Directory documentsDirectory = await getApplicationDocumentsDirectory();
		final path = join(documentsDirectory.path,"SDmovie.db");
		db = await openDatabase(
			path,
			version: 1,
			onCreate: (Database newDb, int version){
				newDb.execute("""
					CREATE TABLE SDmovie
					(
						id INTEGER PRIMARY KEY,
						title TEXT,
						year INTEGER,
						resolution TEXT,
						filename TEXT
					)
				""");
			}
		);
	}

	Future<int> clear(){
		return db.delete('SDmovie');
	}

	Future<List<int>> fill(var response) async{
		List<int> ids=[];
		for(var movie in response['data']){
			int result = await db.insert('SDmovie',movie,conflictAlgorithm: ConflictAlgorithm.ignore);
			ids.add(result);
		}
		return ids;
	}


	Future<List<int>> existing() async{
		List<int> ids=[];
		final result = await db.query(
			"SDmovie",
			columns:["id"],
		);
		for(var i in result){
			ids.add(i['id']);
		}
		return ids;
	}

	Future<MovieModelMini> fetchItem(int id) async{
		final maps = await db.query(
			"SDmovie",
			columns:null,
			where: "id=?",
			whereArgs: [id]
		);

		if(maps.length>0){
			return MovieModelMini.fromDb(maps.first);
		}
		return null;
	}
}

class LDmovie{
	Database db;
	LDmovie(){
		//init();
	}

	void init() async{
		Directory documentsDirectory = await getApplicationDocumentsDirectory();
		final path = join(documentsDirectory.path,"LDmovie.db");
		db = await openDatabase(
			path,
			version: 1,
			onCreate: (Database newDb, int version){
				newDb.execute("""
					CREATE TABLE LDmovie
					(
						title TEXT,
						rated TEXT,
						released TEXT,
						runtime TEXT,
						plot TEXT,
						country TEXT,
						awards TEXT,
						poster TEXT,
						imdbId TEXT,
						type TEXT,
						dvd TEXT,
						boxOffice TEXT,
						production TEXT,
						imdbRating REAL,
						website TEXT,
						resolution TEXT,
						year INTEGER,
						metascore INTEGER,
						imdbVotes INTEGER,
						id INTEGER PRIMARY KEY,
						genre BLOB,
						director BLOB,
						actors BLOB,
						writer BLOB,
						language BLOB,
						ratings BLOB,
						response INTEGER,
						filename TEXT
					)
				""");
			}
		);
	}

	Future<int> clear(){
		return db.delete('LDmovie');
	}

	Future<int> addMovie(MovieModel movie) async{
		return await db.insert('LDmovie',movie.toMap(),conflictAlgorithm: ConflictAlgorithm.ignore);
	}

	Future<MovieModel> fetchMovie(int id) async{
		final maps = await db.query(
			"LDmovie",
			columns:null,
			where: "id=?",
			whereArgs: [id]
		);

		if(maps.length>0){
			return MovieModel.fromDb(maps.first);
		}
		return null;
	}

	Future<List<int>> filterBy(int lb,int ub,String name) async{
		List<int> ids=[];
		final result = await db.query(
			"LDmovie",
			columns:["id"],
			where: "imdbRating<=? and imdbRating>=? and title LIKE '%$name%'",
			whereArgs: [ub,lb]
		);
		for(var i in result){
			ids.add(i['id']);
		}
		return ids;
	}

}


final sdmovie = SDmovie();
final ldmovie = LDmovie();
