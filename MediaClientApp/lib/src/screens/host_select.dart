import 'dart:async';
import'dart:convert';
import 'package:flutter/material.dart';
import '../blocs/host_select_provider.dart';

class HostSelect extends StatelessWidget{

	Widget build(BuildContext context){
		final bloc = HostProvider.of(context);
		return Scaffold(
			appBar:AppBar(title:Text("Select Host")),
			body:buildBody(bloc,context));
	}

	Widget buildBody(HostBloc bloc,BuildContext context){
		return Container(
			margin:EdgeInsets.only(left:20,right:20),
			child:Column(
				crossAxisAlignment:CrossAxisAlignment.center,
				mainAxisAlignment:MainAxisAlignment.center,
				children:<Widget>[
				Container(
					height:50,
					width:double.infinity,
					child:Center(child:Text(
							"Enter IP of Host",
							maxLines: 1,
							softWrap: true,
							overflow: TextOverflow.ellipsis,
							style: TextStyle(
							  fontWeight: FontWeight.w400,
							  fontSize: 20),
						)),
				),Container(height:20),
				Container(
					height:20,
					child:StreamBuilder(
						stream:bloc.addpast,
						builder:(context,AsyncSnapshot<Future<String>> snapshot){
							return FutureBuilder(
								future:snapshot.data,
								builder:(context,AsyncSnapshot<String> ini){
									if(ini.hasData){
										return TextFormField(
											autofocus:false,
											initialValue:ini.data,
											onChanged:bloc.newadd,
										);
									}
									return Text("Loading...");								}
							);
						}
					)
				),
				Container(height:30),
				Container(
					height:30.0,
					width:80.0,
					child:RaisedButton(
						color:Colors.cyan[100],
						onPressed:(){
							bloc.onSubmitAdd();
							FocusScope.of(context).unfocus();
							Navigator.pushNamed(context,'/movielist');
						},
						child:Center(child:Text("Submit")))
				)
			]
		)
		);
	}
}