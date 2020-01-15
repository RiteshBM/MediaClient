import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
	Widget build(context){
		return Column(
				children:[
					Container(
						color: Colors.grey[200],
						height: 220.0,
						width: 360.0,
						margin: EdgeInsets.only(top: 5.0,bottom:5.0)
					),
					Divider(
						height:10.0
						)
				]
			);
	}
}
