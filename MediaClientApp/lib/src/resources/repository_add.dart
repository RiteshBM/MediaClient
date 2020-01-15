import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryAdd{

	addAdd(String ip) async {
		
		if(!ip.contains("http")){
			ip="http://"+ip;
		}
		final prefs = await SharedPreferences.getInstance();
		prefs.setString("local_ip",ip);

	}

	Future<String> getAdd() async {
		final prefs = await SharedPreferences.getInstance();
		final local_ip = prefs.getString('local_ip') ?? "";
		return local_ip;
	}

}
