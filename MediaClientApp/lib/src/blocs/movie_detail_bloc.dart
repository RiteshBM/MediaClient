import 'package:rxdart/rxdart.dart';
import '../models/movie_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class MovieBloc{
	final _repository = Repository();
	final _userMovies = PublishSubject<List<int>>();
	final _movieOutput = BehaviorSubject<Map<int,Future<MovieModel>>>();
	final _movieFetcher = PublishSubject<int>();
	

	// Getter to get stream
	Stream<List<int>> get userMovies => _userMovies.stream;
	Stream<Map<int,Future<MovieModel>>> get movies => _movieOutput.stream;
	// Getter to get sink
	Function(int) get fetchMovie => _movieFetcher.sink.add;



// -----------------------------------------
	final _imdbLb = BehaviorSubject<String>();
	final _imdbUb = BehaviorSubject<String>();
	final _name	= BehaviorSubject<String>();
	// Getter to the stream
	Stream<String> get giLb => _imdbLb.stream;
	Stream<String> get giUb => _imdbUb.stream;
	Stream<String> get gname => _name.stream;




	// Getter to get sink
	Function(String) get iLb => _imdbLb.sink.add;
	Function(String) get iUb => _imdbUb.sink.add;
	Function(String) get name => _name.sink.add;
// -----------------------------------------


	MovieBloc(){
		_movieFetcher.stream.transform(_movieTransformer()).pipe(_movieOutput);
	}

	fetchUserMovies() async{
		final ids = await _repository.fetchUserMovies();
		_userMovies.sink.add(ids);
	}


	clearCache(){
		return _repository.clearCache();
	}


	_movieTransformer(){
		return ScanStreamTransformer(
			(Map<int,Future<MovieModel>> cache, int id, index){
				cache[id] = _repository.fetchMovie(id);
				return cache;
			},
			<int,Future<MovieModel>>{}
		);
	}
	
	updateList() async  {
		int lb=0;
		int ub=10;
		String name="";
		if(_imdbLb.hasValue){
			lb=int.parse(_imdbLb.value);
		}
		if(_imdbUb.hasValue){
			ub=int.parse(_imdbUb.value);
		}
		if(_name.hasValue){
			name=_name.value;
		}
		print("$lb $ub $name");

		final ids = await _repository.filterBy(lb,ub,name);
		print(ids);
		_userMovies.sink.add(ids);
	}

	dispose(){
		_movieOutput.close();
		_movieFetcher.close();
		_imdbLb.close();
		_imdbUb.close();
		_name.close();
	}

}