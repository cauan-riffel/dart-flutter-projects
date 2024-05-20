import 'package:flutter/material.dart';
import 'package:aulinha/models/displays.dart';

void main() {
	runApp(MaterialApp(
		routes: {
			'/':(BuildContext ctx)=>const Topics(),
			'/character':(BuildContext ctx)=>const Characters(),
			'/location':(BuildContext ctx)=>const Location(),
			'/episode':(BuildContext ctx)=>const Episodes(),
		},
	));
}

class Topics extends StatelessWidget{
	@override
	Widget build(ctx){
		return Scaffold(
			appBar:AppBar(
				title:const Text('API'),
			),
			body:DisplayTopics(),
		);
	}
  const Topics({super.key});
}

class Characters extends StatelessWidget{
	@override
	Widget build(ctx){
		return Scaffold(
			appBar:AppBar(
				title:const Text('Characters'),
			),
			body:DisplayCharacters(),
		);
	}
  const Characters({super.key});
}

class Location extends StatelessWidget{
	@override
	Widget build(ctx){
		return Scaffold(
			appBar:AppBar(
				title:const Text('Locations'),
			),
			body:DisplayLocations(),
		);
	}
  const Location({super.key});
}

class Episodes extends StatelessWidget{
	@override
	Widget build(ctx){
		return Scaffold(
			appBar:AppBar(
				title:const Text('Episodes'),
			),
			body:DisplayEpisodes(),
		);
	}
  const Episodes({super.key});
}
