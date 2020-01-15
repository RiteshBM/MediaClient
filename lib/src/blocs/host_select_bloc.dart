import 'package:rxdart/rxdart.dart';
import '../resources/repository_add.dart';
import 'dart:async';

class HostBloc{
	final _repositoryadd = RepositoryAdd();
	final _addstream = BehaviorSubject<String>();
	final _addpaststream = BehaviorSubject<Future<String>>();

	

	// Getter to get stream
	Stream<String> get add => _addstream.stream;
	Stream<Future<String>> get addpast => _addpaststream.stream;

	// Getter to get sink
	Function(String) get newadd => _addstream.sink.add;
	Function(Future<String>) get addpastadd => _addpaststream.sink.add;
// -----------------------------------------
	HostBloc(){
		init();
	}
	onSubmitAdd(){
		String ip;
		if(_addstream.hasValue){
			ip =_addstream.value;
			_repositoryadd.addAdd(ip);
		}
	}

	Future<String> getAdd() async {
		return  _repositoryadd.getAdd();
	}

	init(){
		addpastadd(_repositoryadd.getAdd());
	}


// -----------------------------------------

	dispose(){
		_addstream.close();
	}

}