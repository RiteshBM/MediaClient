import 'package:flutter/material.dart';
import 'host_select_bloc.dart';
export 'host_select_bloc.dart'; 

class HostProvider extends InheritedWidget{
	final HostBloc bloc;

	HostProvider({Key key, Widget child})
		: bloc = HostBloc(),
		super(key:key,child:child);

	bool updateShouldNotify(_) => true;

	static HostBloc of(BuildContext context){
		return (context.inheritFromWidgetOfExactType(HostProvider) as HostProvider).bloc;
	}
}